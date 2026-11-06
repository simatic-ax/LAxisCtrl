NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Direction for phasing and offset operations.
        DirectionPhasingOffset : DINT (
            /// Positive direction of the effective leading value.
            POSITIVE := DINT#1,
            /// Negative direction of the effective leading value.
            NEGATIVE := DINT#2,
            /// Current direction of the effective leading value.
            CURRENT := DINT#3
        ) := CURRENT;
    END_TYPE
END_NAMESPACE
