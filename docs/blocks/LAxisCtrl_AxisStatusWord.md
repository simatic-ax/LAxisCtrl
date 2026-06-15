# AxisStatusWord

## Principle of Operation

The `AxisStatusWord` function block is splitting both status words of an axis into individual bits.

## Interface

### Input Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| axis | DB_ANY | Axis specification |

### Output Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| status | WORD | Status of FB |
| statusWord | DWORD | StatusWord of axis |
| statusWord2 | DWORD | StatusWord2 of axis |
| enable | BOOL | TRUE: The technology object has been enabled |
| error | BOOL | TRUE: An error is present |
| restartActive | BOOL | TRUE: A restart is active. The technology object is being reinitialized |
| onlineStartValuesChanged | BOOL | TRUE: The restart tags have been changed. For the changes to be applied, the technology object must be reinitialized |
| controlPanelActive | BOOL | TRUE: The axis control panel is active |
| homingDone | BOOL | TRUE: The technology object is homed |
| done | BOOL | TRUE: No motion job is in progress and the axis control panel is deactivated |
| standstill | BOOL | TRUE: The axis is at a standstill |
| positioningCommand | BOOL | TRUE: A positioning command is active ("MC_MoveRelative", "MC_MoveAbsolute") |
| jogCommand | BOOL | TRUE: An "MC_MoveJog" job is running |
| velocityCommand | BOOL | TRUE: An "MC_MoveVelocity" job is running |
| homingCommand | BOOL | TRUE: An "MC_Home" job is being processed |
| constantVelocity | BOOL | TRUE: The velocity setpoint is reached. A constant velocity setpoint is output |
| accelerating | BOOL | TRUE: An acceleration operation is active |
| decelerating | BOOL | TRUE: A deceleration operation is active |
| swLimitMinActive | BOOL | TRUE: A negative software limit switch has been approached or exceeded |
| swLimitMaxActive | BOOL | TRUE: A positive software limit switch has been approached or exceeded |
| hwLimitMinActive | BOOL | TRUE: A negative hardware limit switch has been approached or exceeded |
| hwLimitMaxActive | BOOL | TRUE: A positive hardware limit switch has been approached or exceeded |
| synchronizing | BOOL | TRUE: The axis synchronizes to a leading value |
| synchronous | BOOL | TRUE: The axis moves synchronously to a leading value |
| superimposedMotionCommand | BOOL | TRUE: An "MC_MoveSuperimposed" job is running |
| phasingCommand | BOOL | TRUE: An "MC_PhasingAbsolute" or "MC_PhasingRelative" job for the leading value shift is active |
| axisSimulation | BOOL | TRUE: The technology object is in simulation |
| torqueLimitingCommand | BOOL | TRUE: An "MC_TorqueLimiting" job is running |
| inLimitation | BOOL | TRUE: The drive operates at least at the threshold value (default 90%) of the torque limit/force limitation |
| nonPositionControlled | BOOL | TRUE: The axis is not in position-controlled mode |
| kinematicsMotionCommand | BOOL | TRUE: The axis is used for a kinematics job |
| inClamping | BOOL | TRUE: The axis is clamped at a fixed stop |
| motionInCommand | BOOL | TRUE: An "MC_MotionIn" job is active |
| stopCommand | BOOL | TRUE: An "MC_Stop" job is running. The technology object is locked |
| desynchronizingCommand | BOOL | TRUE: An "MC_GearOut" job or "MC_CamOut" job is active. The following axis is desynchronized |
| passingBacklash | BOOL | TRUE: The backlash is traversed. TO.ActualPosition does not hereby change |
| phasingCommandWaiting | BOOL | TRUE: An "MC_PhasingAbsolute" or "MC_PhasingRelative" job for leading value shift is waiting |
| offsetCommand | BOOL | TRUE: An "MC_OffsetAbsolute" or "MC_OffsetRelative" job for following value offset is active |
| offsetCommandWaiting | BOOL | TRUE: An "MC_OffsetAbsolute" or "MC_OffsetRelative" job for following value offset is waiting |
| motionInSuperimposedCommand | BOOL | TRUE: An "MC_MotionInSuperimposed" job is running |
| haltSuperimposedCommand | BOOL | TRUE: An "MC_HaltSuperimposed" job is running |

## Status

The `status` output can have the following values:

| Value | Description |
| ----- | ----------- |
| WORD#16#8002 | Illegal specification of the technology object. Check the specification of the technology object for the "Axis", "Master" or "Cam" parameter. |
| WORD#16#0000 | FB Finished |
