# typeMoveVelocity

## Description

Defines a data structure that is used to parameterize the MC_MoveVelocity instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| velocity | LREAL | Velocity/Speed for motion process (Value = 0.0: Permitted) |
| acceleration | LREAL | Acceleration setpoint for motion process (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| deceleration | LREAL | Deceleration setpoint for motion process (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for velocity specification (Value > 0.0: Smooth velocity profile, the specified value is used; (Value = 0.0: Trapezoid velocity profile; (Value < 0.0: Use of the default value configured in the technology object) |
| direction | [MoveVelocityDirection](../enums/LAxisCtrl_MoveVelocityDirection.md) | Motion direction of the axis (0: The sign of the velocity parameter defines the direction; 1: Positive direction; 2: Negative direction) |
| positionControlled | BOOL | TRUE: Position-controlled operation; FALSE: Non position-controlled operation |
| velocityChangeOnTheFly | BOOL | TRUE: Changing velocity on-the-fly while the command is active and the corresponding input is set; FALSE: Velocity change requires a new rising edge on moveVelocity input |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
