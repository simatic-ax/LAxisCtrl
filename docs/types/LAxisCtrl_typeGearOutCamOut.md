# typeGearOutCamOut

## Description

Defines a data structure that is used to parameterize the MC_GearOut and MC_CamOut instructions.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| slavePosition | LREAL | Stop position of following axis |
| syncProfileReference | [GearOutCamOutSyncProfileReference](../enums/LAxisCtrl_GearOutCamOutSyncProfileReference.md) | Type of desynchronization (0: Desynchronize using dynamic behavior; 1: Desynchronize using leading value distance; 5: Cancel only a pending gearing / camming) |
| masterStopDistance | LREAL | Leading value distance when "SyncProfileReference" = 1 |
| deceleration | LREAL | Deceleration for desynchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| jerk | LREAL | Jerk for desynchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoidal velocity profile; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| syncOutDirection | [GearOutCamOutSyncOutDirection](../enums/LAxisCtrl_GearOutCamOutSyncOutDirection.md) | Desynchronization direction (1: Positive direction; 2: Negative direction; 3: Current direction) |
| gearOutCamOutMode | [GearOutCamOutMode](../enums/LAxisCtrl_GearOutCamOutMode.md) | -1: Automatic detection whether to use a MC_GearOut or MC_CamOut; 0: Use of MC_GearOut; 1: Use of MC_CamOut |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
