NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PhasingProfileReference : DINT (
            /// Only with gearing: Leading value offset using dynamic parameters
            DYN_PARAMS := 0,
            /// Leading value offset using leading value distance as of current leading value position
            LEAD_VAL_DIST_AS_OF_CURR_POS := 1,
            /// Leading value offset using leading value distance as of leading value position "StartPosition"
            LEAD_VAL_DIST_AS_OF_START_POS := 2,
            /// Cancel pending job for leading value offset
            CANCEL_PEND_JOB := 5
        ) := DYN_PARAMS;
    END_TYPE
END_NAMESPACE
