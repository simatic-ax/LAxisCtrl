NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeDiagnostics : STRUCT
            /// Status of FB when error occurred
            status : WORD := WORD#16#0000;
            /// ErrorID of called subfunction
            subfunctionStatus : WORD := WORD#16#0000;
            /// Current basic motion state when error occurred
            basicMotionState : DINT := 0;
            /// Current superimposed motion state when error occurred
            superimposedMotionState : DINT := 0;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
