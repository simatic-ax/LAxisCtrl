USING Siemens.S7.MotionControl;
NAMESPACE Simatic.Ax.LAxisCtrl
    FUNCTION_BLOCK INTERNAL CamInStub
        VAR_IN_OUT
            Master : TO_Axis;
            Slave :	TO_SynchronousAxis;
        END_VAR
        VAR_INPUT
            Cam: DB_ANY;
            Execute : BOOL := FALSE;
            MasterOffset : LREAL :=	0.0;
            SlaveOffset : LREAL := 0.0;
            MasterScaling :	LREAL := 1.0;
            SlaveScaling : LREAL :=	1.0;
            MasterSyncPosition : LREAL := 0.0;
            SyncProfileReference : DINT := 1;
            MasterStartDistance : LREAL := 0.0;
            Velocity : LREAL :=	-1.0;
            Acceleration : LREAL :=	-1.0;
            Deceleration : LREAL :=	-1.0;
            Jerk : LREAL :=	-1.0;
            ApplicationMode : DINT := 0;
            SyncDirection :	DINT :=	3;
        END_VAR
        VAR_OUTPUT
            StartSync :	BOOL;
            InSync : BOOL;
            Busy : BOOL;
            CommandAborted : BOOL;
            Error :	BOOL;
            ErrorId : Word;
            EndOfProfile : BOOL;
        END_VAR
        VAR CONSTANT
            ERROR_INVALID_TECHNOLOGY_OBJECT	: WORD := WORD#16#8002;
        END_VAR
        StartSync := FALSE;
        InSync := FALSE;
        Busy := FALSE;
        CommandAborted := FALSE;
        EndOfProfile := FALSE;

        IF Execute THEN
          Error := TRUE;
          ErrorId := ERROR_INVALID_TECHNOLOGY_OBJECT;
        ELSE
          Error := FALSE;
          ErrorId := WORD#16#0000;
        END_IF;
    END_FUNCTION_BLOCK
END_NAMESPACE
