# typeDiagnostics

## Description

Defines a data structure that contains the status information of the implemented MC instruction inside of [AxisControl](../blocks/LAxisCtrl_AxisControl.md).

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| status | WORD | Status of FB when error occurred |
| subfunctionStatus | WORD | ErrorID of called subfunction |
| basicMotionState | DINT | Current basic motion state when error occurred |
| superimposedMotionState | DINT | Current superimposed motion state when error occurred |

## Usage

This type is used in as an output of the function block [AxisControl](../blocks/LAxisCtrl_AxisControl.md#output-parameters).
