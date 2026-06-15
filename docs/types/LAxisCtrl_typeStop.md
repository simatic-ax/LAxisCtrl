# typeStop

## Description

Defines a data structure that is used to parameterize the MC_Halt instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| deceleration | LREAL | Deceleration setpoint for stop (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for stop (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) |
| abortAcceleration | BOOL | TRUE: The acceleration is set to 0.0 at the start of the job, and the deceleration immediately builds up; FALSE: The current acceleration at the start of the job is reduced using the configured jerk. Afterwards, the deceleration builds up |
| haltMode | [HaltMode](../enums/LAxisCtrl_HaltMode.md) | Select the motion which is to be stopped (0: The basic motion and the superimposed motion are stopped; 1: The basic motion is stopped. The superimposed motion remains active) |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
