# typeFastStopParams

## Description

Defines a data structure that is used to parameterize the MC_Stop dynamics for the fastStop feature.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| mode | DInt | Mode for dynamic behavior (0: Emergency stop; 1: Not permitted; 2: Stop with maximum dynamic values; 3: Stop with specified dynamics). See corresponding parameter of MC_ instruction in TIA Portal help (information system) |
| deceleration | LREAL | Only relevant if 'mode' = 3: Deceleration for the braking ramp (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The deceleration configured in "Technology object > Configuration > Extended parameters > Dynamic defaults" is used -> <TO>.DynamicDefaults.Deceleration) |
| jerk | LREAL | Only relevant if 'mode' = 3: Jerk for the braking ramp (Value > 0.0: The specified value is used; Value = 0.0: No jerk limitation; Value < 0.0: The jerk configured in "Technology object > Configuration > Extended parameters > Dynamic defaults" is used -> <TO>.DynamicDefaults.Jerk) |
| abortAcceleration | BOOL | TRUE: Acceleration is set to 0.0. The configured deceleration is built up immediately; FALSE: The acceleration is reduced using the configured jerk. The configured deceleration then builds up |

## Usage

This type is used in the fastStop config structure [typeFastStop](./typeFastStop.md).
