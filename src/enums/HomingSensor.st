NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        HomingSensor : DINT (
            /// Operative Encoder
            OPERATIVE_ENCODER := 0,
            /// Encoder 1
            ENCODER1 := 1,
            /// Encoder 2
            ENCODER2 := 2,
            /// Encoder 3
            ENCODER3 := 3,
            /// Encoder 4
            ENCODER4 := 4
        ) := OPERATIVE_ENCODER;
    END_TYPE
END_NAMESPACE
