# typeGeneralSettings

## Description

Defines a data structure that is used to parameterize behaviour of LAxisCtrl.AxisControl function block.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| stopOnError | BOOL | TRUE: In case of error the axis will be stopped automatically with fastStop dynamics |
| resetWithRestart | BOOL | TRUE: Reinitialization of the technology object and acknowledgment of pending technology alarms. The technology object is reinitialized with the configured start values; FALSE: Acknowledgment of queued technology alarms |
| resetAlsoFBErrors | BOOL | TRUE: FB errors with 'valid' = FALSE and 'busy' = TRUE that are normally reset via resetting all command inputs are also reset with a rising edge at input 'resetAxis', i.e. there is no need to reset all command inputs to reset an error of the FB |
| abortWaitingSyncCmd | BOOL | TRUE: Abort waiting synchronous command (MC_GEARINPOS, MC_CAMIN) in case of new basic motion command automatically |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./typeAxisConfig.md).
