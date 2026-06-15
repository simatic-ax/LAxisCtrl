# typeFastStop

## Description

Defines a data structure that is used to parameterize the MC_Halt instruction (alternative dynamics).

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| deceleration | LREAL | Deceleration for fast stop (Value > 0.0: The specified value is used; Value <= 0.0: Emergency deceleration of the technology object is used) |
| jerk | LREAL | Jerk for fast stop (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) |
| abortAcceleration | BOOL | TRUE: The acceleration is set to 0.0 at the start of the job, and the deceleration immediately builds up; FALSE: The current acceleration at the start of the job is reduced using the configured jerk. Afterwards, the deceleration builds up |
| replaceStopPossible | BOOL | TRUE: Fast stop command can be replaced by another command |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
