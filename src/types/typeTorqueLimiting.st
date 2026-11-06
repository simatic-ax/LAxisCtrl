NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeTorqueLimiting : STRUCT
            /// Value of force/torque limiting (in the configured unit of measurement) (Value >= 0.0: The specified value is used; Value < 0.0: Use of the default value configured in the technology object)
            limit : LREAL := -1.0;
            /// 0: Force/Torque limiting; 1: Fixed stop detection
            mode : TorqueLimitingMode;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
