USING Siemens.S7.MotionControl;
NAMESPACE Simatic.Ax.LAxisCtrl
    FUNCTION_BLOCK INTERNAL OffsetRelativeStub
        VAR_IN_OUT
            Slave : TO_SynchronousAxis;
        END_VAR
        VAR_INPUT
            Execute : BOOL := FALSE;
            Offset : LREAL := 0.0;
            ProfileReference : DINT := 1;
            OffsetDistance : LREAL := 0.0;
            StartPosition : LREAL := 0.0;
            Direction : DINT := 3;
        END_VAR
        VAR_OUTPUT
            Done : BOOL;
            Busy : BOOL;
            CommandAborted : BOOL;
            Error : BOOL;
            ErrorId : WORD;
            CoveredOffset : LREAL;
            StartOffset : BOOL;
        END_VAR
        VAR CONSTANT
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
        END_VAR
        Done := FALSE;
        Busy := FALSE;
        CommandAborted := FALSE;
        CoveredOffset := 0.0;
        StartOffset := FALSE;

        IF Execute THEN
            Error := TRUE;
            ErrorId := ERROR_INVALID_TECHNOLOGY_OBJECT;
        ELSE
            Error := FALSE;
            ErrorId := WORD#16#0000;
        END_IF;
    END_FUNCTION_BLOCK
END_NAMESPACE
