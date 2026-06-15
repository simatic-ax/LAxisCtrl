NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        GearInAbsoluteSyncProfileReference : DINT (
            /// Synchronization in advance using dynamic parameters
            IN_ADV_DYN_PARAMS := 0,
            /// Synchronization in advance using leading value distance
            IN_ADV_LEAD_VAL_DIST := 1,
            /// Subsequent synchronization using leading value distance
            SUBSEQ_LEAD_VAL_DIST := 3,
            /// Subsequent synchronization using leading value distance starting from current leading value position with calculated synchronous position of the following axis
            SUBSEQ_LEAD_VAL_DIST_AS_OF_CURR_LEAD_VAL_POS := 4,
            /// Subsequent synchronization using leading value distance with calculated synchronous position of the following axis
            SUBSEQ_LEAD_VAL_DIST_AS_OF_SPEC_LEAD_VAL_POS := 5
        ) := IN_ADV_LEAD_VAL_DIST;
    END_TYPE
END_NAMESPACE
