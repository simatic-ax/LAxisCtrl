#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# rewrite-apax.sh
#
# Rewrite apax.yml in place for one Motion Control variant build.
#
# Behavior:
#   - Reads the package name from apax.yml's `.name` and renames it to
#     "<name>-v<mc>".
#   - For each MC family (native, OOP) currently present in apax.yml's
#     `dependencies`, replaces the v<N> suffix in the key with v<mc>.
#     Preserves the existing semver range — native and OOP versions are not
#     aligned upstream, so the range lives in apax.yml, not in mc-versions.yml.
#   - A library may use only native, only OOP, or both. Whatever's in apax.yml
#     gets rewritten; nothing is added that wasn't already there.
#   - Removes the lockfile so `apax install` regenerates it.
#
# Naming convention is hardcoded to mirror the upstream Siemens MC packages
# (`@ax/simatic-motioncontrol-native-v<N>`). Override here if your fork needs
# a different scheme.
#
# Required tools: mikefarah/yq (v4+).
# ----------------------------------------------------------------------------

# `set -e`  : stop the script the moment any command exits non-zero.
# `set -u`  : treat references to unset variables as errors.
# `set -o pipefail` : in a pipeline `a | b | c`, fail if ANY stage fails
#                     (default would only check the last one).
# Together: "fail loudly and early" — important in CI where silent failures
# can publish broken packages.
set -euo pipefail

# These are the prefixes of upstream Siemens motion-control package names.
# Each ends with `-v` so we can append a digit to form e.g.
# `@ax/simatic-motioncontrol-native-v8`.
MC_FAMILY_PREFIXES=(
  "@ax/simatic-motioncontrol-native-v"
  "@ax/simatic-motioncontrol-v"
)

# Initialize variables before parsing args.
mc=""

# `$#` is the number of remaining positional arguments ($1, $2, ...).
# This loop walks them: read one or two, `shift` to discard them, repeat.
while [[ $# -gt 0 ]]; do
  case "$1" in
    # `--mc 8` — read the value into $mc, then shift TWO (the flag + value).
    --mc)    mc="$2"; shift 2 ;;
    # `*` is the catch-all in `case`. `>&2` redirects to stderr (channel 2)
    # so error messages don't get mixed into stdout. `exit 2` aborts with
    # a non-zero status; CI will mark the job failed.
    *) echo "rewrite-apax.sh: unknown arg '$1'" >&2; exit 2 ;;
  esac
done

# `[[ -z "$mc" ]]` is true when $mc is the empty string.
# Always quote variable expansions ("$mc") to handle values with spaces or
# special characters safely.
if [[ -z "$mc" ]]; then
  echo "rewrite-apax.sh: missing required --mc" >&2
  exit 2
fi

# `command -v yq` prints the path of `yq` if it's on PATH, else returns
# non-zero. `>/dev/null 2>&1` discards both stdout and stderr — we only care
# about the exit status. The leading `!` negates it: "if yq is NOT found".
if ! command -v yq >/dev/null 2>&1; then
  echo "rewrite-apax.sh: yq not found on PATH" >&2
  exit 2
fi

# `yq -r '.name' apax.yml` prints the value of the top-level
# `name` field with -r ("raw", no surrounding quotes).
base_name=$(yq -r '.name' apax.yml)

# The check fails if name is empty OR the
# literal string "null" — yq prints "null" when the field is missing.
if [[ -z "$base_name" || "$base_name" == "null" ]]; then
  echo "rewrite-apax.sh: apax.yml has no .name field" >&2
  exit 2
fi

# Compose the new package name.
# `${var}-suffix` is parameter expansion — concatenation with explicit braces
# so bash knows where the variable name ends.
new_name="${base_name}-v${mc}"

# yq's `strenv(X)` reads the bash environment variable named X. We `export`
# the value so yq sees it. This is safer than embedding $new_name directly
# into the yq expression — the value can contain `@`, `/`, quotes, etc.,
# which would otherwise need escaping in the yq DSL.
# `-i` means "in-place edit": yq overwrites apax.yml with the new content.
export NEW_NAME="$new_name"
yq -i '.name = strenv(NEW_NAME)' apax.yml

# For each MC family, find any existing key matching `<prefix><digits>` and
# replace its suffix with v<mc>. The original range is preserved.

# Track whether we changed anything, so we can warn at the end if not.
rewrote_any=0

# `"${ARRAY[@]}"` expands to all array elements as separate quoted words.
# This iterates over the two MC family prefixes.
for prefix in "${MC_FAMILY_PREFIXES[@]}"; do
  export PREFIX="$prefix"

  # The yq expression below:
  #   (.dependencies // {})  -> read .dependencies, default to empty map if missing
  #   | keys                 -> get list of dependency names
  #   | map(select(...))     -> keep only names matching the regex
  #   | .[]                  -> emit each match on its own line
  # Regex `^<prefix>[0-9]+$` matches e.g. `@ax/simatic-motioncontrol-v10`
  # exactly (no extra chars) — the `$` end-anchor stops it from matching
  # something like `...-v10-experimental`.
  #
  # Trailing `|| true` prevents the script from aborting (under `set -e`)
  # if yq exits non-zero when there are zero matches.
  matches=$(yq -r '
    (.dependencies // {}) | keys | map(select(. | test("^" + strenv(PREFIX) + "[0-9]+$"))) | .[]
  ' apax.yml || true)

  # `<<< "$matches"` is a "here string": feed the value as stdin to `read`.
  # `IFS=` clears the field separator so leading/trailing whitespace is
  # preserved in $old_key. `read -r` disables backslash interpretation.
  # The loop runs once per line in $matches.
  while IFS= read -r old_key; do
    # Skip blank lines (e.g. when $matches itself is empty).
    # `&&` runs the right side only if the left side succeeded.
    [[ -z "$old_key" ]] && continue

    new_key="${prefix}${mc}"

    # If the existing key is already at the requested MC version, skip the
    # rewrite (no-op). This is the common case for the highest-MC matrix row.
    if [[ "$old_key" == "$new_key" ]]; then
      rewrote_any=1
      echo "rewrite-apax.sh: keeping $new_key (already at v$mc)"
      continue
    fi

    # Same export-then-strenv pattern: pass values into yq via the environment
    # so special chars in the keys can't break the yq expression.
    export OLD_KEY="$old_key"
    export NEW_KEY="$new_key"

    # yq has no rename operation, so we do it in two steps:
    #   1. copy the value under the new key
    #   2. delete the old key
    # `|` chains yq operations like a pipeline.
    yq -i '
      .dependencies[strenv(NEW_KEY)] = .dependencies[strenv(OLD_KEY)]
      | del(.dependencies[strenv(OLD_KEY)])
    ' apax.yml
    rewrote_any=1
    echo "rewrite-apax.sh: renamed $old_key -> $new_key"
  done <<< "$matches"
done

# If apax.yml had no MC dep at all, this is almost certainly a misconfiguration.
# Warn but don't fail — the build will fail later anyway if the library actually
# needs an MC dep.
if [[ "$rewrote_any" -eq 0 ]]; then
  echo "rewrite-apax.sh: WARNING no MC family dependency found in apax.yml; nothing to rewrite" >&2
fi

# Lockfile reflects the previous dep set; let `apax install` regenerate it.
# `-f` ("force") suppresses "file not found" errors.
rm -f apax-lock.json

# Final summary line, useful when scanning CI logs.
echo "rewrite-apax.sh: name=$new_name mc=v$mc"
