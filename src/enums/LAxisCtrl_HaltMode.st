NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        HaltMode : DINT (
            /// The basic motion and the superimposed motion are stopped.
            ALL_MOTIONS := 0,
            /// The basic motion is stopped. The superimposed motion remains active.
            BASIC_MOTION := 1
        ) := ALL_MOTIONS;
    END_TYPE
END_NAMESPACE
