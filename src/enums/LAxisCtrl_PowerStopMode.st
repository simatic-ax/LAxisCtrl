NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PowerStopMode : INT (
            /// Emergency stop
            EMERGENCY_STOP := 0,
            /// Immediate stop
            IMMEDIATE_STOP := 1,
            /// Stop with maximum dynamic values
            STOP_MAX_DYN_VAL := 2,
            /// Coasting down
            COAST_DOWN := 3
        ) := EMERGENCY_STOP;
    END_TYPE
END_NAMESPACE
