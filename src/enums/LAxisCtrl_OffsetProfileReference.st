NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        OffsetProfileReference : DINT (
            /// Leading value offset using leading value distance as of current leading value position
            LEAD_VAL_DIST_AS_OF_CUR_POS := 1,
            /// Leading value offset using leading value distance as of leading value position "StartPosition"
            LEAD_VAL_DIST_AS_OF_START_POS := 2,
            /// Cancel pending job for leading value offset
            CANCEL_PEND_JOB := 5
        ) := LEAD_VAL_DIST_AS_OF_CUR_POS;
    END_TYPE
END_NAMESPACE
