NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Synchronization profile for gearing operation.
        GearInProfile : DINT (
            /// Synchronization in advance using dynamic parameters.
            IN_ADVANCE_BY_DYNAMICS_PARAMETERS := DINT#0,
            /// Synchronization in advance using leading value distance.
            IN_ADVANCE_BY_LEADING_VALUE_DISTANCE := DINT#1,
            // Reserved := DINT#2,
            /// Subsequent synchronization using leading value distance.
            SUBSEQUENT_BY_LEADING_VALUE_DISTANCE := DINT#3,
            /// Subsequent synchronization using leading value distance starting from current leading value position with calculated synchronous position of the following axis.
            SUBSEQUENT_BY_LEADING_VALUE_DISTANCE_IMMEDIATELY := DINT#4,
            /// Subsequent synchronization using leading value distance with calculated synchronous position of the following axis (V9).
            SUBSEQUENT_BY_LEADING_VALUE_DISTANCE_AT_LEADING_SYNC_POSITION := DINT#5
        ) := IN_ADVANCE_BY_LEADING_VALUE_DISTANCE;
    END_TYPE
END_NAMESPACE
