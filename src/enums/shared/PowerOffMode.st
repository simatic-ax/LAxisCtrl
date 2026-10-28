NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Mode for powering off an axis.
        PowerOffMode : INT (
            /// Using emergency stopping dynamics.
            EMERGENCY_STOP := INT#0,
            /// Using immediate stopping dynamics (via OFF3 ramp-down time from drive system).
            IMMEDIATE_STOP := INT#1,
            /// Using maximum stopping dynamics.
            MAX_DYNAMICS_STOP := INT#2,
            /// Coasting down.
            COASTING_DOWN := INT#3
        ) := EMERGENCY_STOP;
    END_TYPE
END_NAMESPACE
