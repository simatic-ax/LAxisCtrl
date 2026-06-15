# typeJog

## Description

Defines a data structure that is used to parameterize the MC_Jog instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| velocity | LREAL | Velocity for jogging (Value > 0.0: The specified value is used; Value = 0.0: Permitted; Value < 0.0: The absolute value of the specified value is used) |
| acceleration | LREAL | Acceleration for jogging (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| deceleration | LREAL | Deceleration for jogging (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for jogging (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) |
| positionControlled | BOOL | TRUE: Position-controlled mode; FALSE: Non position-controlled operation |
| increment | LREAL | Increment/distance for incremental jogging |
| mode | [JogMode](../enums/LAxisCtrl_JogMode.md) | 0: Continuous jogging; 1: Incremental jogging new increment (starts with new increment); 2: Incremental jogging continue increment (continue the last increment if not completed) |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
