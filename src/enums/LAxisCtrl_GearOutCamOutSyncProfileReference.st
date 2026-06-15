NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        GearOutCamOutSyncProfileReference : DINT (
            /// Desynchronize using dynamic parameters
            DYN_PARAMS := 0,
            /// Desynchronize using leading value distance
            LEAD_VAL_DIST := 1,
            /// Canceling pending gearing
            CANCEL_PEND_SYNC_OP := 5
        ) := LEAD_VAL_DIST;
    END_TYPE
END_NAMESPACE
