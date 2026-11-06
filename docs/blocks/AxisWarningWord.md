# AxisWarningWord

## Principle of Operation

The `AxisWarningWord` function block is splitting the warning word of an axis into individual bits.

## Interface

### Input Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| axis | DB_ANY | Axis specification |

### Output Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| status | WORD | Status of FB |
| warningWord | DWORD | WarningWord of axis |
| systemWarning | BOOL | TRUE: A system-internal error has occurred |
| configWarning | BOOL | TRUE: Configuration error (One or several configuration parameters are adjusted internally) |
| userWarning | BOOL | TRUE: Error in user program at a Motion Control instruction or its use |
| commandNotAccepted | BOOL | TRUE: Job cannot be executed. A Motion Control instruction cannot be executed because the necessary conditions have not been met |
| driveWarning | BOOL | TRUE: Warning of the drive. When a warning message is pending at the drive that does not result in a TO alarm, this bit is not set. Evaluate the drive warnings directly using the status word of the drive |
| sensorWarning | BOOL | TRUE: Error in encoder system |
| dynamicError | BOOL | TRUE: Specified dynamic values are limited to permissible values |
| communicationWarning | BOOL | TRUE: Communication error (Missing or faulty communication) |
| swLimitMin | BOOL | TRUE: The negative software limit switch has been approached |
| swLimitMax | BOOL | TRUE: The positive software limit switch has been approached |
| homingWarning | BOOL | TRUE: Error during homing operation (The homing cannot be completed) |
| followingErrorWarning | BOOL | TRUE: Warning limit of following error monitoring reached/exceeded |
| positioningWarning | BOOL | TRUE: Positioning error |
| peripheralWarning | BOOL | TRUE: Error accessing a logical address |
| synchronousWarning | BOOL | TRUE: Error during synchronous operation (The leading axis specified in the Motion Control instruction was not configured as a possible leading axis) |
| adaptionWarning | BOOL | TRUE: Error in automatic data transfer |

## Status

The `status` output can have the following values:

| Value | Description |
| ----- | ----------- |
| WORD#16#8002 | Illegal specification of the technology object. Check the specification of the technology object for the "Axis", "Master" or "Cam" parameter. |
| WORD#16#0000 | FB Finished |
