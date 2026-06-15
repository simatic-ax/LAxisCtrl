# AxisErrorWord

## Principle of Operation

The `AxisErrorWord` function block is splitting the error word of an axis into individual bits.

## Interface

### Input Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| axis | DB_ANY | Axis specification |

### Output Parameters

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| status | WORD | Status of FB |
| errorWord | DWORD | ErrorWord of axis |
| systemFault | BOOL | TRUE: System fault (A system-internal error has occurred) |
| configFault | BOOL | TRUE: Configuration error (One or more configuration parameters are inconsistent or invalid) |
| userFault | BOOL | TRUE: User fault (Error in user program at a Motion Control instruction or its use) |
| commandNotAccepted | BOOL | TRUE: Job cannot be executed. A Motion Control instruction cannot be executed because the necessary conditions have not been met |
| driveFault | BOOL | TRUE: Error in drive |
| sensorFault | BOOL | TRUE: Error in encoder system |
| dynamicError | BOOL | TRUE: Specified dynamic values are limited to permissible values |
| communicationFault | BOOL | TRUE: Communication error (Missing or faulty communication) |
| swLimit | BOOL | TRUE: Software limit switch reached or overtraveled |
| hwLimit | BOOL | TRUE: Hardware limit switch reached or overtraveled |
| homingError | BOOL | TRUE: Error during homing operation (The homing cannot be completed) |
| followingErrorFault | BOOL | TRUE: Following error limits exceeded |
| positioningFault | BOOL | TRUE: Positioning error |
| peripheralError | BOOL | TRUE: Error accessing a logical address |
| synchronousError | BOOL | TRUE: Error during synchronous operation (The leading axis specified in the Motion Control instruction was not configured as a possible leading axis) |
| adaptionError | BOOL | TRUE: Error in automatic data transfer |

## Status

The `status` output can have the following values:

| Value | Description |
| ----- | ----------- |
| WORD#16#8002 | Illegal specification of the technology object. Check the specification of the technology object for the "Axis", "Master" or "Cam" parameter. |
| WORD#16#0000 | FB Finished |
