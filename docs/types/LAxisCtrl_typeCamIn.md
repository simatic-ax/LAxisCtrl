# typeCamIn

## Description

Defines a data structure that is used to parameterize the MC_CamIn instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| masterOffset | LREAL | Offset of the leading values of the cam (The cam technology object is not changed) when "SyncProfileReference" = 0, 1, 3, 4, 7 |
| slaveOffset | LREAL | Offset of the following values of the cam (The cam technology object is not changed) when "SyncProfileReference" = 0, 1, 3, 4, 6 |
| masterScaling | LREAL | Scaling the leading values of the cam |
| slaveScaling | LREAL | Scaling the following values of the cam |
| masterSyncPosition | LREAL | Position of the leading axis (relative to the start position of the cam), from which the axes are synchronous and synchronization is complete (The value must be within the definition of the cam) when "SyncProfileReference" = 0, 1, 6. Position of the leading axis (relative to the start position of the cam) from which the synchronization begins (The value must be within the definition of the cam) when "SyncProfileReference" = 3. Position of the leading axis (relative to the start position of the cam to be changed), from which the axes are synchronous (The value must be within the definition of the cam to be changed) when "SyncProfileReference" = 2, 5, 7 |
| syncProfileReference | [CamInSyncProfileReference](../enums/LAxisCtrl_CamInSyncProfileReference.md) | Position of the leading axis (relative to the start position of the cam), from which the axes are synchronous and synchronization is complete (The value must be within the definition of the cam) when "SyncProfileReference" = 0, 1, 6. Position of the leading axis (relative to the start position of the cam) from which the synchronization begins (The value must be within the definition of the cam) when "SyncProfileReference" = 3. Position of the leading axis (relative to the start position of the cam to be changed), from which the axes are synchronous (The value must be within the definition of the cam to be changed) when "SyncProfileReference" = 2, 5, 7 |
| masterStartDistance | LREAL | Leading value distance when "SyncProfileReference" = 1, 3, 4, 6 |
| velocity | LREAL | Velocity for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| acceleration | LREAL | Acceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| deceleration | LREAL | Deceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| jerk | LREAL | Jerk for synchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| applicationMode | [CamInApplicationMode](../enums/LAxisCtrl_CamInApplicationMode.md) | Application of the cam (0: Once/not cyclic; 1: Cyclic (absolute application on the following value side); 2: Cyclic appending (continuously appending on the following value side)) |
| syncDirection | [CamInSyncDirection](../enums/LAxisCtrl_CamInSyncDirection.md) | Direction for synchronization only in effect for axes with activated modulo setting (1: Forward direction; 2: Backward direction; 3: Shortest way) when "SyncProfileReference" = 0, 1, 3, 4, 6 |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
