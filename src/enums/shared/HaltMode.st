NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Mode for halting (decelerating to standstill) a motion of an axis.
        HaltMode : DINT (
            /// The basic motion and the superimposed motion are stopped.
            ALL_AXIS_MOTION := DINT#0,
            /// Only the basic motion is stopped and superimposed motion remains active.
            ONLY_BASIC_MOTION := DINT#1
        ) := ALL_AXIS_MOTION;
    END_TYPE
END_NAMESPACE
