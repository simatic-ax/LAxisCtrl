# typeGearInVelocity

## Description

Defines a data structure that is used to parameterize the MC_GearInVelocity instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| continuousUpdate | BOOL | TRUE: Specify gear ratio continuously; FALSE: Specify gear ratio once at the start of the job with a positive edge |
| ratioNumerator | DINT | Gear ratio numerator (permitted integer values: -2147483648 to 2147483647; value 0 not permitted) |
| ratioDenominator | DINT | Gear ratio denominator (permitted integer values: 1 to 2147483647) |
| acceleration | LREAL | Acceleration for the synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The acceleration configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. TO.DynamicDefaults.Acceleration) |
| deceleration | LREAL | Deceleration for the synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The deceleration configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. TO.DynamicDefaults.Deceleration) |
| jerk | LREAL | Jerk for the synchronization (Value > 0.0: The specified value is used; Value = 0.0: No jerk limitation; Value < 0.0: The jerk configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. TO.DynamicDefaults.Jerk) |
| positionControlled | BOOL | Position control of the following axis (TRUE: Position-controlled mode; FALSE: Non-position-controlled operation) |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
