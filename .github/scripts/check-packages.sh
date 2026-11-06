#!/usr/bin/env bash
# Validates packages/<variant>/apax.yml against the root apax.yml and README.md.
# Requires mikefarah/yq v4+.
set -euo pipefail

export MC_DEP_RE='^@ax-mc/s7-motioncontrol-v[0-9]+-lib$'
# Strips the fields a variant may change; everything else must match the root.
NORMALIZE='del(.name) | del(.variables)
  | .dependencies = ((.dependencies // {}) | with_entries(select(.key | test(strenv(MC_DEP_RE)) | not)))'

errors=0
fail() { echo "check-packages.sh: $*" >&2; errors=$((errors + 1)); }

shopt -s nullglob
manifests=(packages/*/apax.yml)
if [[ ${#manifests[@]} -eq 0 ]]; then
  echo "check-packages.sh: no packages/*/apax.yml found" >&2
  exit 1
fi

root_full=$(yq -o=json -I=0 '.' apax.yml)
root_norm=$(yq -o=json -I=0 "$NORMALIZE" apax.yml)
root_matches=0

for manifest in "${manifests[@]}"; do
  folder=$(basename "$(dirname "$manifest")")
  name=$(yq -r '.name' "$manifest")

  if [[ "${name#@*/}" != "$folder" ]]; then
    fail "$manifest: name '$name' does not match folder '$folder'"
  fi
  if [[ "$(yq -o=json -I=0 "$NORMALIZE" "$manifest")" != "$root_norm" ]]; then
    fail "$manifest: differs from apax.yml outside name, variables and the MC dependency"
  fi
  if [[ "$(yq -o=json -I=0 '.' "$manifest")" == "$root_full" ]]; then
    root_matches=$((root_matches + 1))
  fi
  if ! grep -qF "\`$name\`" README.md; then
    fail "README.md: package '$name' is missing from the package variants table"
  fi
done

if [[ $root_matches -ne 1 ]]; then
  fail "apax.yml must be identical to exactly one package (found $root_matches)"
fi

if [[ $errors -gt 0 ]]; then
  exit 1
fi
echo "check-packages.sh: ${#manifests[@]} packages OK"
