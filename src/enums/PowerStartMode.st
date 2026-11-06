NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PowerStartMode : DINT (
            /// Enable positioning axis/synchronous axis not position-controlled
            NOT_POSITION_CONTROLLED := 0,
            /// Enable positioning axis/synchronous axis position-controlled
            POSITION_CONTROLLED := 1
        ) := POSITION_CONTROLLED;
    END_TYPE
END_NAMESPACE
