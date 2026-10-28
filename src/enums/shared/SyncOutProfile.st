NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Desynchronization profile for synchronous or camming operation.
        SyncOutProfile : DINT (
            /// Desynchronize using dynamic parameters.
            DYNAMICS_PARAMETERS := DINT#0,
            /// Desynchronize using leading value distance.
            LEADING_VALUE_DISTANCE := DINT#1,
            /// Canceling pending gearing.
            CANCEL_PENDING_SYNC_IN := DINT#5
        ) := LEADING_VALUE_DISTANCE;
    END_TYPE
END_NAMESPACE
