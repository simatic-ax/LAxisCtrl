# typeGearInAbsolute

## Description

Defines a data structure that is used to parameterize the MC_GearInPos instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| ratioNumerator | DINT | Gear ratio numerator (permitted integer values: -2147483648 to 2147483647; value 0 not permitted) |
| ratioDenominator | DINT | Gear ratio denominator (permitted integer values: 1 to 2147483647) |
| masterSyncPosition | LREAL | Synchronous position of leading axis |
| slaveSyncPosition | LREAL | Synchronous position of following axis |
| syncProfileReference | [GearInAbsoluteSyncProfileReference](../enums/LAxisCtrl_GearInAbsoluteSyncProfileReference.md) | Type of synchronization (0: Synchronization in advance using dynamic parameters; 1: Synchronization in advance using leading value distance; 3: Subsequent synchronization using leading value distance; 4: Subsequent synchronization using leading value distance starting from current leading value position with calculated synchronous position of the following axis; 5: Subsequent synchronization using leading value distance with calculated synchronous position of the following axis) |
| masterStartDistance | LREAL | Leading value distance when "SyncProfileReference" = 1, 3, 4, 5 |
| velocity | LREAL | Velocity for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| acceleration | LREAL | Acceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| deceleration | LREAL | Deceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| jerk | LREAL | Jerk for synchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0 |
| syncDirection | [GearInAbsoluteSyncDirection](../enums/LAxisCtrl_GearInAbsoluteSyncDirection.md) | Direction for synchronization only in effect for axes with activated modulo setting (1: Forward direction; 2: Backward direction; 3: Shortest way) |
| ratioChangeOnTheFly | BOOL | TRUE: Changing gear ratio on-the-fly while the command is active and the corresponding input is set; FALSE: Ratio change requires a new rising edge at gearInAbsolute input |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
