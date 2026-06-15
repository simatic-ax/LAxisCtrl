# typeHoming

## Description

Defines a data structure that is used to parameterize the MC_Home instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| position | LREAL | The specified value is used according to the selected "Mode" |
| mode | [HomingMode](../enums/LAxisCtrl_HomingMode.md) | Operation mode; 0: Direct homing (absolute); 1: Direct homing (relative); 2: Passive homing (without reset); 3: Active homing; 5: Active homing (Position parameter has no effect); 6: Absolute encoder adjustment (relative); 7: Absolute encoder adjustment (absolute); 8: Passive homing; 9: Abort passive homing; 10: Passive homing (Position parameter has no effect); 11: Set setpoINT position (absolute); 12: Shift the setpoINT position (relative); 13: Incremental encoder adjustment |
| sensor | [HomingSensor](../enums/LAxisCtrl_HomingSensor.md) | Only relevant for S7-1500T: Selection of the absolute encoder ("Mode" = 6, 7) or incremental encoder ("Mode" = 13) to be calibrated; 0: Operative encoder; 1..4: Encoder 1..4 (S7-1500T) |
| extendedMode | [HomingExtendedMode](../enums/LAxisCtrl_HomingExtendedMode.md) | -1: No extended homing mode (parameter "mode" is effective); 0: Homing on fixed stop; 1: Homing on fixed stop with moving out of clamping; 2: Homing on fixed stop with moving to target position |
| extendedModeTorqueLimit | LREAL | Value of the torque/force for extended homing mode |
| extendedModeTargetPosition | LREAL | Target position when 'extendedMode' = 2 |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
