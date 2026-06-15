# typePhasing

## Description

Defines a data structure that is used to parameterize the MC_PhasingAbsolute and MC_PhasingRelative instructions.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| phaseShift | LREAL | Absolute or relative leading value shift |
| velocity | LREAL | Velocity for leading value shift, added to synchronous operation motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| acceleration | LREAL | Acceleration for leading value shift, added to synchronous operation motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| deceleration | LREAL | Deceleration for leading value shift, added to synchronous operation motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for leading value shift, added to synchronous operation motion (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) |
| profileReference | [PhasingProfileReference](../enums/LAxisCtrl_PhasingProfileReference.md) | Type of traversing of the leading value offset (0: Only with gearing: Traverse leading value offset using dynamics parameters; 1: Traverse leading value offset via leading value distance starting from current leading value position; 2: Traverse leading value offset from leading value position "StartPosition"; 5: Cancel only one waiting job for the leading value offset) |
| phasingDistance | LREAL | Leading value distance (Distance of the leading axis during the traversing of the leading value offset) when "ProfileReference" = 1, 2 |
| startPosition | LREAL | Leading value position starting from which the leading value offset is traversed when "ProfileReference" = 2 |
| direction | [PhasingDirection](../enums/LAxisCtrl_PhasingDirection.md) | Direction of the leading value distance (1: Positive direction; 2: Negative direction; 3: Current direction) when "ProfileReference" = 1, 2 |
| phaseAbsolute | BOOL | TRUE: Shift the leading value as an absolute shift; FALSE: Shift the leading value relative to the existing leading value shift |
| phaseShiftChangeOnTheFly | BOOL | TRUE: Changing phase shift on-the-fly at absolute phasing while the command is active and the corresponding input is set; FALSE: Phase shift change requires a new rising edge at phasing input |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
