# AxisControl

## Principle of Operation

The `AxisControl` function block allows operating all axis types (TO_SpeedAxis, TO_PositioningAxis, TO_SynchronousAxis, TO_ExternalEncoder) with a S7-1500 or S7-1500T CPU or a S7-1200 G2 CPU.

If no synchronous operation functionality is required, the input master can be left unconnected.
If no camming functionality is required, the input cam can be left unconnected.

Supported functionalities:

- Enable / disable axis
- Reset of an axis (acknowledgment of the errors at the technology object / restart of the technology object)
- Jogging (incremental / continuous)
- Move axis at velocity / speed setpoint (position-controlled / non position-controlled)
- Stop / fast stop
- Moving / stopping an axis with force / torque limiting with and without fixed stop detection
- Homing (active / passive / setting of a position value / absolute encoder adjustment / homing on fixed stop)
- Positioning (absolute / relative)
- Superimposed relative positioning
- Superimposed halt
- Gearing (absolute / relative / velocity)
- Camming (offset and scaling for master and slave, cyclic and non-cyclic cam disk, different synchronization modes)
- Gear out / cam out
- Phasing (shift leading value of an existing synchronous operation)
- Offset (shift following value of an existing synchronous operation)
- Stop and disable a slave axis without desynchronizing (synchronizedMotionSimulation)
- Changing the velocity, position, gear ratio, phase shift and offset on-the-fly
- Unconditionally opening and closing of the holding brake

## Interface

### Input Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| enable | BOOL | TRUE: Enable functionality of FB |
| enableAxis | BOOL | TRUE: Set axis enable; FALSE: Remove axis enable. MC_Power is used internally |
| resetAxis | BOOL | Rising edge: Acknowledgment of technology alarms or restart of the axis (depending on config). MC_Reset is used internally |
| openBrake | BOOL | TRUE: Unconditionally open holding brake if axis is not enabled (e.g. for service purposes). Note: Do not modify this input while disabling of the axis is active (input enableAxis := FALSE and output axisEnabled = TRUE). MC_SetAxisSTW is used internally |
| jogForward | BOOL | Rising edge: Move an axis in jog mode (forward); Falling edge: Stop jogging. MC_MoveJog is used internally |
| jogBackward | BOOL | Rising edge: Move an axis in jog mode (backward); Falling edge: Stop jogging. MC_MoveJog is used internally |
| moveVelocity | BOOL | Rising edge: Move an axis at constant velocity/speed. MC_MoveVelocity is used internally |
| stop | BOOL | Rising edge: Brake an axis until it comes to a standstill. Note: MC_Halt is triggered internally |
| fastStop | BOOL | Rising edge: Brake an axis until it comes to a standstill (with fastStop dynamics). Note: MC_Halt is triggered internally |
| torqueLimiting | BOOL | TRUE: Enable force/torque limiting. MC_TorqueLimiting is used internally |
| homing | BOOL | Rising edge: Home axis. MC_Home is used internally |
| posRelative | BOOL | Rising edge: Move an axis relative to its position when execution of the job began. MC_MoveRelative is used internally |
| posAbsolute | BOOL | Rising edge: Move an axis to an absolute position. MC_MoveAbsolute is used internally |
| posSuperimposed | BOOL | Rising edge: Start a superimposed positioning. MC_MoveSuperimposed is used internally |
| haltSuperimposed | BOOL | Rising edge: Decelerate a superimposed motion to zero velocity. MC_HaltSuperimposed is used internally |
| gearInRelative | BOOL | Rising edge: Start a gearing operation (relative). MC_GearIn is used internally |
| gearInAbsolute | BOOL | Rising edge: Start a gearing operation (absolute). MC_GearInPos is used internally |
| gearInVelocity | BOOL | Rising edge: Start a gearing operation (velocity synchronous). MC_GearInVelocity is used internally |
| gearOutCamOut | BOOL | Rising edge: End a gearing/camming operation. MC_GearOut/MC_CamOut is used internally |
| camIn | BOOL | Rising edge: Start a camming operation. MC_CamIn is used internally |
| phasing | BOOL | Rising edge: Start a phasing operation. MC_PhasingRelative/MC_PhasingAbsolute is used internally |
| offset | BOOL | Rising edge: Start an offset operation. MC_OffsetRelative/MC_OffsetAbsolute is used internally |
| axis | DB_ANY | Reference to axis technology object to be controlled |
| master | DB_ANY | Reference to leading axis technology object for synchronous motion |
| cam | DB_ANY | Cam technology object |
| config | [typeAxisConfig](../types/LAxisCtrl_typeAxisConfig.md#structure) | Structure for parameters |

### Output Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| valid | BOOL | TRUE: Valid set of output values available at the FB |
| busy | BOOL | TRUE: FB is working and new output values can be expected |
| error | BOOL | TRUE: An error occurred while processing the FB |
| status | [AxisStatus](../enums/LAxisCtrl_AxisStatus.md) | Current status of FB (16#0000 - 16#7FFF: Status of the FB, 16#8000 - 16#FFFF: Error identification) |
| statusText | String[39] | Text of current status of FB |
| subfunctionStatus | WORD | Status of internally called subfunctions (ErrorID of Motion Control instructions) |
| axisEnabled | BOOL | TRUE: The technology object is enabled. Motion commands can be executed |
| resetActive | BOOL | TRUE: Reset/Restart of the axis is active |
| commandBusy | BOOL | TRUE: The selected basic motion command is being executed |
| commandDone | BOOL | TRUE: The selected basic motion command has completed without error |
| commandAborted | BOOL | TRUE: The selected basic motion command has been aborted |
| inVelocity | BOOL | TRUE: The setpoint velocity/speed was reached and will be maintained |
| inLimitation | BOOL | TRUE: The drive is operating at the force/torque limit |
| homingCommandBusy | BOOL | TRUE: Homing command is being executed |
| homingCommandDone | BOOL | TRUE: Homing command has completed without error |
| homingCommandAborted | BOOL | TRUE: Homing command has been aborted |
| superimposedBusy | BOOL | TRUE: The selected superimposed motion command is being executed |
| superimposedDone | BOOL | TRUE: The selected superimposed motion command has completed without error |
| superimposedAborted | BOOL | TRUE: The selected superimposed motion command has been aborted |
| superimposedStart | BOOL | TRUE: The selected superimposed motion is active |
| inClamping | BOOL | TRUE: The drive is kept at the fixed stop (clamping), the axis position is within the positioning tolerance |
| startSync | BOOL | TRUE: The axis is synchronizing to the leading axis / desynchronizing from the leading axis (Note: signal is only valid for the currently selected synchronous functionality, see outputs 'gearInAbsoluteSelected', 'gearInVelocitySelected', 'gearOutCamOutSelected' or 'camInSelected') |
| inSync | BOOL | TRUE: The axis is synchronized to the leading axis (Note: signal is only valid for the currently selected synchronous functionality, see outputs 'gearInRelativeSelected', 'gearInAbsoluteSelected', 'gearInVelocitySelected' or 'camInSelected') |
| endOfProfile | BOOL | TRUE: The end of the cam has been reached. The output is displayed for at least one call when the cam is used cyclically |
| inSimulation | BOOL | TRUE: Synchronous operation is being simulated |
| jogSelected | BOOL | TRUE: Jogging is active |
| moveVelocitySelected | BOOL | TRUE: Moving with constant velocity/speed is active |
| stopSelected | BOOL | TRUE: Stopping is active |
| fastStopSelected | BOOL | TRUE: Stopping is active (with fastStop dynamics) |
| torqueLimitingSelected | BOOL | TRUE: Force/Torque limiting is active |
| homingSelected | BOOL | TRUE: Homing is active |
| posRelativeSelected | BOOL | TRUE: Relative positioning is active |
| posAbsoluteSelected | BOOL | TRUE: Absolute positioning is active |
| posSuperimposedSelected | BOOL | TRUE: Superimposed positioning is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted) |
| haltSuperimposedSelected | BOOL | TRUE: Superimposed halting is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted) |
| gearInRelativeSelected | BOOL | TRUE: Relative gearing is active (See also outputs: commandBusy, commandDone, commandAborted, inSync) |
| gearInAbsoluteSelected | BOOL | TRUE: Absolute gearing is active (See also outputs: commandBusy, commandDone, commandAborted, startSync, inSync) |
| gearInVelocitySelected | BOOL | TRUE: Velocity gearing is active (See also outputs: commandBusy, commandDone, commandAborted, startSync, inSync) |
| gearOutCamOutSelected | BOOL | TRUE: End a gearing/camming operation is active (See also outputs: commandBusy, commandDone, commandAborted, startSync) |
| camInSelected | BOOL | TRUE: Camming is active (See also outputs: commandBusy, commandDone, commandAborted, startSync, inSync) |
| phasingSelected | BOOL | TRUE: Phasing is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted, superimposedStart) |
| offsetSelected | BOOL | TRUE: Offset is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted, superimposedStart) |
| diagnostics | [typeDiagnostics](../types/LAxisCtrl_typeDiagnostics.md#structure) | Diagnostics structure |
