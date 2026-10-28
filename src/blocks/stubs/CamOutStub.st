USING Siemens.S7.MotionControl;
NAMESPACE Simatic.Ax.LAxisCtrl
    FUNCTION_BLOCK INTERNAL CamOutStub
        VAR_IN_OUT
            Slave : TO_SynchronousAxis;
        END_VAR
        VAR_INPUT
            Execute : BOOL := FALSE;
            SlavePosition : LREAL := 0.0;
            SyncProfileReference : DINT := 1;
            MasterStopDistance : LREAL := 0.0;
            Deceleration : LREAL := -1.0;
            Jerk : LREAL := -1.0;
            SyncOutDirection : DINT := 3;
        END_VAR
        VAR_OUTPUT
            StartSyncOut : BOOL;
            Done : BOOL;
            Busy : BOOL;
            CommandAborted : BOOL;
            Error : BOOL;
            ErrorId : WORD;
        END_VAR
        VAR CONSTANT
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
        END_VAR
        StartSyncOut := FALSE;
        Done := FALSE;
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
