# typePosRelative

## Description

Defines a data structure that is used to parameterize the MC_MoveRelative instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| distance | LREAL | Distance for positioning process |
| velocity | LREAL | Velocity setpoint for relative positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| acceleration | LREAL | Acceleration setpoint for relative positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| deceleration | LREAL | Deceleration setpoint for relative positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) |
| jerk | LREAL | Jerk for relative positioning (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) |
| direction | [PosRelDirection](../enums/LAxisCtrl_PosRelDirection.md) | Motion direction of the axis (0: The sign of the distance parameter defines the direction; 1: Positive direction; 2: Negative direction) |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
