NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Profile for phasing operation.
        PhasingProfile : DINT (
            /// Leading value offset using dynamic parameters (only applicable for gearing operation).
            DYNAMICS_PARAMETERS := DINT#0,
            /// Leading value offset using leading value distance as of current leading value position.
            LEADING_VALUE_DISTANCE := DINT#1,
            /// Leading value offset using leading value distance as of leading value position StartPosition.
            LEADING_VALUE_DISTANCE_AT_START_POSITION := DINT#2,
            /// Cancel pending job for leading value offset.
            CANCEL_PENDING_PHASING := DINT#5
        ) := DYNAMICS_PARAMETERS;
    END_TYPE
END_NAMESPACE
