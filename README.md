# @simatic-ax/laxisctrl

## Description

The LAxisCtrl (Axis Control) library for SIMATIC S7-1500 provides a simplified way of programming various motion control tasks for axes. This library offers extensive functionalities such as:

- Fundamental Axis Control: Enabling/disabling axes, resetting them (acknowledging errors or restarting the technology object), and managing the motor holding brake.
- Diverse Motion Capabilities: Jogging (incremental/continuous), moving at a set velocity/speed (both position-controlled and non-position-controlled), and various stopping methods (normal and fast). It also supports moving and stopping with force/torque limiting, including fixed stop detection.
- Homing Options: A variety of homing procedures, such as active, passive, setting a position value, absolute encoder adjustment, and homing on a fixed stop.
- Positioning Flexibility: Absolute, relative, and superimposed relative positioning, along with superimposed halt functionalities.
- Advanced Synchronous Motion: Comprehensive gearing (absolute, relative, and velocity), camming (with options for offset, scaling, cyclic/non-cyclic cam disks, and different synchronization modes), and the ability to gear out or cam out. It also includes phasing (shifting the leading value) and offsetting (shifting the following value) for existing synchronous operations.
- Dynamic Adjustments & Special Modes: Features like stopping and disabling a slave axis without desynchronizing (synchronizedMotionSimulation), and on-the-fly adjustments to velocity, position, gear ratio, phase shift, and offset.
- Diagnostic Feedback: Provides critical status information through statusWord, errorWord, and warningWord.

The LAxisCtrl.AxisControl function block within this library is compliant with PLCopen specifications, ensuring a standardized interface and behavior. It's versatile, supporting various axis types, with a detailed overview of supported motion control functionalities provided based on the assigned technology object type.

## Getting started

Install with Apax:

> If not yet done login to the GitHub registry first.
> More information you'll find [here](https://github.com/simatic-ax/.github/blob/main/docs/personalaccesstoken.md)

```cli
apax add @simatic-ax/laxisctrl
```

Add the namespace in your ST code:

```iec-st
USING Simatic.Ax.LAxisCtrl;
```

## Library functionality

| Functions   | Description             |
| ----------- | ----------------------- |
| [AxisStatusWord](docs/blocks/LAxisCtrl_AxisStatusWord.md) | Function to retrieve the status words of an axis technology object as individual bits |
| [AxisWarningWord](docs/blocks/LAxisCtrl_AxisWarningWord.md) | Function to retrieve the warning word of an axis technology object as individual bits |
| [AxisErrorWord](docs/blocks/LAxisCtrl_AxisErrorWord.md) | Function to retrieve the error word of an axis technology object as individual bits |

| Function Blocks | Description           |
| --------------- | --------------------- |
| [AxisControl](docs/blocks/LAxisCtrl_AxisControl.md) | Function block that executes various motion control tasks of an axis technology object |

## Examples

### Basic motion program

<details>

```iec-st
USING Simatic.Ax;
USING Siemens.Simatic.MotionControl.Native;
USING Simatic.Ax.LAxisCtrl;

TYPE INTERNAL
    BasicMotion_States : UINT(
        IDLE := UINT#0,
        POWER_ON := UINT#10,
        MOVE_REL := UINT#20,
        HOME := UINT#30,
        MOVE_ABS := UINT#40,
        MOVE_VEL := UINT#50,
        MOVE_HALT := UINT#60,
        POWER_OFF := UINT#70
    ) := IDLE;
END_TYPE

FUNCTION_BLOCK BasicMotion
    VAR_INPUT
        execute : BOOL;
        axis : DB_ANY;
    END_VAR

    VAR_OUTPUT
        done : BOOL;
        busy : BOOL;
        error : BOOL;
        errorId : WORD;
    END_VAR

    VAR
        _executeOld : BOOL;
        _done : BOOL;
        _busy : BOOL;
        _error : BOOL;
        _errorID : WORD;
        _checked : BOOL;
        _state : BasicMotion_States;
        _instLAxisCtrl : AxisControl;
    END_VAR

    IF execute AND NOT _executeOld THEN
        _done := FALSE;
        _error := FALSE;
        _errorId := WORD#0000;

        _checked := FALSE;

        _instLAxisCtrl(enable := TRUE, axis := axis);

        _busy := TRUE;
        _state := BasicMotion_States#POWER_ON;

    ELSIF NOT execute AND _executeOld AND NOT _busy THEN
        _done := FALSE;
        _busy := FALSE;
        _error := FALSE;
        _errorId := WORD#0000;

        _instLAxisCtrl(enable := FALSE, axis := axis);

        _state := BasicMotion_States#IDLE;
    END_IF;

    _executeOld := execute;

    // stop further block execution when error is pending
    IF _error OR _done THEN
        RETURN;
    END_IF;

    CASE _state OF
        BasicMotion_States#IDLE:
            ;

        BasicMotion_States#POWER_ON:
            IF _instLAxisCtrl.valid THEN
                _instLAxisCtrl.enableAxis := TRUE;

                IF _instLAxisCtrl.axisEnabled THEN
                _state := BasicMotion_States#MOVE_REL;
                END_IF;
            END_IF;

        BasicMotion_States#MOVE_REL:
            _instLAxisCtrl.config.posRelative.distance := 3600;
            _instLAxisCtrl.config.posRelative.velocity := 600;
            _instLAxisCtrl.posRelative := TRUE;

            IF _instLAxisCtrl.commandBusy AND _instLAxisCtrl.posRelativeSelected AND NOT _checked THEN
                _checked := TRUE;
            END_IF;

            IF _instLAxisCtrl.commandDone AND _checked THEN
                _checked := FALSE;
                _instLAxisCtrl.posRelative := FALSE;
                _state := BasicMotion_States#HOME;
            END_IF;

        BasicMotion_States#HOME:
            _instLAxisCtrl.config.homing.position := 0;
            _instLAxisCtrl.config.homing.mode := HomingMode#ABS_ENC_ADJUST_ABS;
            _instLAxisCtrl.homing := TRUE;

            IF _instLAxisCtrl.homingCommandBusy AND _instLAxisCtrl.homingSelected AND NOT _checked THEN
                _checked := TRUE;
            END_IF;

            IF _instLAxisCtrl.homingCommandDone AND _checked THEN
                _checked := FALSE;
                _instLAxisCtrl.homing := FALSE;
                _state := BasicMotion_States#POWER_OFF;
            END_IF;

        BasicMotion_States#MOVE_ABS:
            _instLAxisCtrl.config.posAbsolute.position := 1800;
            _instLAxisCtrl.config.posAbsolute.velocity := 600;
            _instLAxisCtrl.config.posAbsolute.direction := PosAbsDirection#NEGATIVE;
            _instLAxisCtrl.posAbsolute := TRUE;

            IF _instLAxisCtrl.commandBusy AND _instLAxisCtrl.posAbsoluteSelected AND NOT _checked THEN
                _checked := TRUE;
            END_IF;

            IF _instLAxisCtrl.commandDone AND _checked THEN
                _checked := FALSE;
                _instLAxisCtrl.posAbsolute := FALSE;
                _state := BasicMotion_States#MOVE_VEL;
            END_IF;

        BasicMotion_States#MOVE_VEL:
            _instLAxisCtrl.config.moveVelocity.velocity := 123;
            _instLAxisCtrl.config.moveVelocity.velocityChangeOnTheFly := TRUE;
            _instLAxisCtrl.moveVelocity := TRUE;

            IF _instLAxisCtrl.commandBusy AND _instLAxisCtrl.moveVelocitySelected AND NOT _checked THEN
                _checked := TRUE;
                _instLAxisCtrl.moveVelocity := FALSE;
            END_IF;

            IF NOT _instLAxisCtrl.moveVelocitySelected AND _checked THEN
                _instLAxisCtrl.config.moveVelocity.velocity := 321;
                _instLAxisCtrl.moveVelocity := TRUE;
            END_IF;

            IF _instLAxisCtrl.commandBusy AND _instLAxisCtrl.moveVelocitySelected AND _checked THEN
                _checked := FALSE;
                _instLAxisCtrl.moveVelocity := FALSE;
                _state := BasicMotion_States#MOVE_HALT;
            END_IF;

        BasicMotion_States#MOVE_HALT:
            _instLAxisCtrl.stop := TRUE;

            IF _instLAxisCtrl.commandBusy AND _instLAxisCtrl.stopSelected AND NOT _checked THEN
                _checked := TRUE;
            END_IF;

            IF _instLAxisCtrl.commandDone AND _checked THEN
                _checked := FALSE;
                _instLAxisCtrl.stop := FALSE;
                _state := BasicMotion_States#POWER_OFF;
            END_IF;

        BasicMotion_States#POWER_OFF:
            _instLAxisCtrl.enableAxis := FALSE;

            IF NOT _instLAxisCtrl.axisEnabled THEN
                _done := TRUE;
            END_IF;
    END_CASE;

    // cyclic call of LAxisCtrl.AxisControl
    _instLAxisCtrl(axis := axis);

    // error handling of LAxisCtrl.AxisControl
    IF _instLAxisCtrl.error THEN
        _error := TRUE;
        _errorId := _instLAxisCtrl.status;
    END_IF;

    // set execution state of block
    IF _error THEN
        _busy := FALSE;
        _done := FALSE;
    ELSIF _done THEN
        _busy := FALSE;
        _error := FALSE;
        _errorId := WORD#0000;
    END_IF;

    // outputs
    done := _done;
    busy := _busy;
    error := _error;
    errorId := _errorId;
END_FUNCTION_BLOCK
```

</details>

## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using a pull request.

## License and Legal information

Please read the [Legal information](LICENSE.md)
