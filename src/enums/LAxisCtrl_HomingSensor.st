NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        HomingSensor : DINT (
            /// Operative Encoder
            OPERATIVE_ENC := 0,
            /// Encoder 1
            ENC1 := 1,
            /// Encoder 2
            ENC2 := 2,
            /// Encoder 3
            ENC3 := 3,
            /// Encoder 4
            ENC4 := 4
        ) := OPERATIVE_ENC;
    END_TYPE
END_NAMESPACE
