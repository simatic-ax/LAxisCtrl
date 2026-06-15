NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        JogMode : DINT (
            /// Continuous jogging
            CONTINUOUS_JOGGING := 0,
            /// Incremental jogging new increment (starts with new increment)
            INCREMENTAL_JOGGING := 1,
            /// Incremental jogging continue increment (continue the last increment if not completed)
            INCREMENTAL_JOGGING_CONTINUOUS := 2
        ) := CONTINUOUS_JOGGING;
    END_TYPE
END_NAMESPACE
