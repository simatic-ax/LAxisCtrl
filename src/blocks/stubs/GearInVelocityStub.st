USING Siemens.S7.MotionControl;
NAMESPACE Simatic.Ax.LAxisCtrl
    FUNCTION_BLOCK INTERNAL GearInVelocityStub
        VAR_IN_OUT
            Master : TO_Axis;
            Slave : TO_SynchronousAxis;
        END_VAR
        VAR_INPUT
            Execute : BOOL := FALSE;
            ContinuousUpdate : BOOL := FALSE;
            RatioNumerator : DINT := 1;
            RatioDenominator : DINT := 1;
            Acceleration : LREAL := -1.0;
            Deceleration : LREAL := -1.0;
            Jerk : LREAL := -1.0;
            PositionControlled : BOOL := FALSE;
        END_VAR
        VAR_OUTPUT
            StartSync : BOOL;
            InSync : BOOL;
            ContinuousUpdateActive : BOOL;
            Busy : BOOL;
            CommandAborted : BOOL;
            Error : BOOL;
            ErrorId : WORD;
        END_VAR
        VAR CONSTANT
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
        END_VAR
        StartSync := FALSE;
        InSync := FALSE;
        ContinuousUpdateActive := FALSE;
        Busy := FALSE;
        CommandAborted := FALSE;

        IF Execute THEN
            Error := TRUE;
            ErrorId := ERROR_INVALID_TECHNOLOGY_OBJECT;
        ELSE
            Error := FALSE;
            ErrorId := WORD#16#0000;
        END_IF;
    END_FUNCTION_BLOCK
END_NAMESPACE
