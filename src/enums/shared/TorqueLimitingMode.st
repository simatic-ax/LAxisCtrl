NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Mode for torque limiting operation.
        TorqueLimitingMode : DINT (
            /// Torque/Force limiting.
            TORQUE_LIMITING := DINT#0,
            /// Fixed stop detection.
            FIXED_STOP_DETECTION := DINT#1
        ) := TORQUE_LIMITING;
    END_TYPE
END_NAMESPACE
