NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        CamInSyncProfileReference : DINT (
            /// Synchronization in advance using dynamic parameters
            IN_ADV_DYN_PARAMS := 0,
            /// Synchronization in advance using leading value distance
            IN_ADV_LEAD_VAL_DIST := 1,
            /// Direct synchronous setting
            DIRECT_IMMEDIATELY := 2,
            /// Subsequent synchronization using leading value distance
            SUBSEQ_LEAD_VAL_DIST := 3,
            /// Subsequent synchronization using leading value distance starting from current leading value position
            SUBSEQ_LEAD_VAL_DIST_AS_OF_CURR_POS := 4,
            /// Direct synchronous setting at the end of the cam
            DIRECT_AT_END_OF_CAM := 5,
            /// Synchronization in advance using leading value distance starting from current leading value position
            IN_ADV_LEAD_VAL_DIST_AS_OF_CURR_POS := 6,
            /// Direct synchronous setting at specific leading value position
            DIRECT_AT_LEAD_VAL_POS := 7
        ) := IN_ADV_LEAD_VAL_DIST;
    END_TYPE
END_NAMESPACE
