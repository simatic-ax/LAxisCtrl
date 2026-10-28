USING Siemens.S7.MotionControl;
NAMESPACE Simatic.Ax.LAxisCtrl
    FUNCTION_BLOCK INTERNAL PhasingAbsoluteStub
        VAR_IN_OUT
            Master : TO_Axis;
            Slave : TO_SynchronousAxis;
        END_VAR
        VAR_INPUT
            Execute : BOOL := FALSE;
            PhaseShift : LREAL := 0.0;
            Velocity : LREAL := -1.0;
            Acceleration : LREAL := -1.0;
            Deceleration : LREAL := -1.0;
            Jerk : LREAL := -1.0;
            ProfileReference : DINT := 0;
            PhasingDistance : LREAL := 0.0;
            StartPosition : LREAL := 0.0;
            Direction : DINT := 3;
        END_VAR
        VAR_OUTPUT
            Done : BOOL;
            Busy : BOOL;
            CommandAborted : BOOL;
            Error : BOOL;
            ErrorId : WORD;
            AbsolutePhaseShift : LREAL;
            StartPhasing : BOOL;
        END_VAR
        VAR CONSTANT
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
        END_VAR
        Done := FALSE;
        Busy := FALSE;
        CommandAborted := FALSE;
        AbsolutePhaseShift := 0.0;
        StartPhasing := FALSE;

        IF Execute THEN
            Error := TRUE;
            ErrorId := ERROR_INVALID_TECHNOLOGY_OBJECT;
        ELSE
            Error := FALSE;
            ErrorId := WORD#16#0000;
        END_IF;
    END_FUNCTION_BLOCK
END_NAMESPACE
