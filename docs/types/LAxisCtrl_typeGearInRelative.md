# typeGearInRelative

## Description

Defines a data structure that is used to parameterize the MC_GearIn instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| ratioNumerator | DINT | Gear ratio numerator (permitted integer values: -2147483648 to 2147483647; value 0 not permitted) |
| ratioDenominator | DINT | Gear ratio denominator (permitted integer values: 1 to 2147483647) |
| acceleration | LREAL | Acceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| deceleration | LREAL | Deceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for synchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) |
| ratioChangeOnTheFly | BOOL | TRUE: Changing gear ratio on-the-fly while the command is active and the corresponding input is set; FALSE: Ratio change requires a new rising edge at gearInRelative input |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
