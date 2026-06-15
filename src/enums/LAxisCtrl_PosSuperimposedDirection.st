NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PosSuperimposedDirection : DINT (
            /// The sign of the distance parameter defines the direction
            DEFINED_BY_SIGN_OF_DISTANCE := 0,
            /// Positive direction
            POSITIVE := 1,
            /// Negative direction
            NEGATIVE := 2
        ) := DEFINED_BY_SIGN_OF_DISTANCE;
    END_TYPE
END_NAMESPACE
