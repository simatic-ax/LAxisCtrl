USING Siemens.S7.MotionControl;
NAMESPACE Simatic.Ax.LAxisCtrl
    FUNCTION_BLOCK INTERNAL SynchronizedMotionSimulationStub
        VAR_IN_OUT
            Slave : TO_SynchronousAxis;
        END_VAR
        VAR_INPUT
            Enable : BOOL := FALSE;
        END_VAR
        VAR_OUTPUT
            InSimulation : BOOL;
            Busy : BOOL;
            Error : BOOL;
            ErrorId : WORD;
        END_VAR
        VAR CONSTANT
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
        END_VAR
        Busy := FALSE;
        InSimulation := FALSE;

        IF Enable THEN
            Error := TRUE;
            ErrorId := ERROR_INVALID_TECHNOLOGY_OBJECT;
        ELSE
            Error := TRUE;
            ErrorId := WORD#16#0000;
        END_IF;
    END_FUNCTION_BLOCK
END_NAMESPACE
