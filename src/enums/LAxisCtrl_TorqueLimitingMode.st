NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        TorqueLimitingMode : DINT (
            /// Force/Torque limiting
            LIMITING := 0,
            /// Fixed stop detection
            FIXED_STOP := 1
        ) := LIMITING;
    END_TYPE
END_NAMESPACE
