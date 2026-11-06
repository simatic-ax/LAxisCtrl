# HomingMode

| Symbol | Value | Description |
| ------ | ----- | ----------- |
| DIRECT_ABS | 0 | The current position of the technology object is set to the value of parameter "Position". Note: In the case of an axis with several encoders, the offset of the position at the sensors of all encoders is also applied with a position correction with the "Mode" parameter = 0. This prevents the sensors from diverging. |
| DIRECT_REL | 1 | The current position of the technology object is shifted by the value of parameter "Position". Note: In the case of an axis with several encoders, the offset of the position at the sensors of all encoders is also applied with a position correction with the "Mode" parameter = 1. This prevents the sensors from diverging. |
| PASSIVE_WITHOUT_RESET | 2 | Function same as "Mode" = 8 with the difference that the "homed" status is not reset when the function is enabled. |
| ACTIVE | 3 | The positioning axis/synchronous axis technology object performs a homing movement according to the configuration. After the completion of the motion, the axis is positioned at the value of the "Position" parameter. |
| ACTIVE_IGNORE_POSITION | 5 | The positioning axis/synchronous axis technology object performs a homing movement according to the configuration. After completion of the motion, the axis is positioned at the home position configured under "Technology object > Configuration > Extended parameters > Homing > Active homing". (<TO>.Homing.HomePosition) |
| ABS_ENC_ADJUST_REL | 6 | The current position is shifted by the value of parameter "Position". The calculated absolute value offset is stored retentively in the CPU. (<TO>.StatusSensor[1..4].AbsEncoderOffset) |
| ABS_ENC_ADJUST_ABS | 7 | The current position is set to the value of parameter "Position". The calculated absolute value offset is stored retentively in the CPU. (<TO>.StatusSensor[1..4].AbsEncoderOffset) |
| PASSIVE | 8 | When the homing mark is detected, the actual value is set to the value of the "Position" parameter. |
| ABORT_PASSIVE | 9 | An active job for passive homing is aborted. |
| PASSIVE_IGNORE_POSITION | 10 | When the homing mark is detected, the actual value is set to the home position configured under "Technology object > Configuration > Extended parameters > Homing > Passive homing". (<TO>.Homing.HomePosition) |
| SET_SETPOINT_POSITION_ABS | 11 | The set position of the technology object is set to the value of the "Position" parameter. The following error remains. |
| SET_SETPOINT_POSITION_REL | 12 | The set position of the technology object is shifted by the value of the "Position" parameter. The following error remains. |
| INC_ENC_ADJUST | 13 | The current position is set to the value of parameter "Position". |
