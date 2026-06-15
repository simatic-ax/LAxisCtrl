# typeOffset

## Description

Defines a data structure that is used to parameterize the MC_OffsetAbsolute and MC_OffsetRelative instructions.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| offset | LREAL | Absolute or relative offset shift |
| profileReference | [OffsetProfileReference](../enums/LAxisCtrl_OffsetProfileReference.md) | Type of traversing of the following value offset (0: Only with gearing, 1: Traverse following value offset using leading value distance starting from the current effective leading value position; 2: Traverse following value offset using leading value distance from the effective leading value position "StartPosition"; 5: Cancel only one waiting job for the following value offset) |
| offsetDistance | LREAL | Effective leading value distance while traversing the following value offset when "ProfileReference" = 1, 2 |
| startPosition | LREAL | Effective leading value position starting from which the following value offset is traversed when "ProfileReference" = 2 |
| direction | [OffsetDirection](../enums/LAxisCtrl_OffsetDirection.md) | Direction of the leading value distance (1: Positive direction; 2: Negative direction; 3: Current direction) when "ProfileReference" = 1, 2 |
| offsetAbsolute | BOOL | TRUE: Shift the following value as an absolute shift; FALSE: Shift the following value relative to the existing following value shift |
| offsetChangeOnTheFly | BOOL | TRUE: Changing offset shift on-the-fly at absolute offset shift while the command is active and the corresponding input is set; FALSE: Offset shift change requires a new rising edge at offset input |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
