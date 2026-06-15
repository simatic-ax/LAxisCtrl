NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PhasingDirection : DINT (
            /// The leading value distance is in the positive direction of motion of the leading value.
            POSITIVE := 1,
            /// The leading value distance is in the negative direction of motion of the leading value.
            NEGATIVE := 2,
            /// The leading value distance is in the current direction of motion of the leading value.
            CURRENT := 3
        ) := CURRENT;
    END_TYPE
END_NAMESPACE
