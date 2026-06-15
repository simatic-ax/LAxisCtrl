# typeHaltSuperimposed

## Description

Defines a data structure that is used to parameterize the MC_HaltSuperimposed instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| deceleration | LREAL | Deceleration of the superimposed motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The deceleration configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. TO.DynamicDefaults.Deceleration) |
| jerk | LREAL | Jerk of the superimposed motion (Value > 0.0: Constant-acceleration velocity profile of the superimposed motion; the specified jerk is used; Value = 0.0: Trapezoidal velocity profile of the superimposed motion; Value < 0.0: The jerk configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. TO.DynamicDefaults.Jerk) |
| abortAcceleration | BOOL | TRUE: The acceleration of the superimposed motion is set to 0.0 at the start of the job, the deceleration builds up immediately; FALSE: The current acceleration of the superimposed motion at the start of the job is reduced using the configured jerk. Afterwards, the deceleration builds up |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
