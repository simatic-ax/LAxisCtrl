# typePosAbsolute

## Description

Defines a data structure that is used to parameterize the MC_MoveAbsolute instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| position | LREAL | Absolute target position |
| velocity | LREAL | Velocity setpoint for absolute positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| acceleration | LREAL | Acceleration setpoint for absolute positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| deceleration | LREAL | Deceleration setpoint for absolute positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for absolute positioning (Value > 0.0: Smooth velocity profile, the specified value is used; (Value = 0.0: Trapezoid velocity profile; (Value < 0.0: Use of the default value configured in the technology object) |
| direction | [PosAbsDirection](../enums/LAxisCtrl_PosAbsDirection.md) | Motion direction of the axis (1: Positive direction; 2: Negative direction; 3: Shortest way) |
| positionChangeOnTheFly | BOOL | TRUE: Changing position on-the-fly while the command is active and the corresponding input is set; FALSE: Position change requires a new rising edge at posAbsolute input |
| velocityChangeOnTheFly | BOOL | TRUE: Changing velocity on-the-fly while the command is active and the corresponding input is set; FALSE: Velocity change requires a new rising edge at posAbsolute input |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
