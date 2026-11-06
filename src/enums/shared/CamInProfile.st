NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Synchronization profile for the camming operation.
        CamInProfile : DINT (
            /// Synchronization in advance using dynamic parameters.
            IN_ADVANCE_BY_DYNAMICS_PARAMETERS := DINT#0,
            /// Synchronization in advance using leading value distance.
            IN_ADVANCE_BY_LEADING_VALUE_DISTANCE := DINT#1,
            /// Direct synchronous setting.
            DIRECT := DINT#2,
            /// Subsequent synchronization using leading value distance.
            SUBSEQUENT_BY_LEADING_VALUE_DISTANCE := DINT#3,
            /// Subsequent synchronization using leading value distance starting from current leading value position.
            SUBSEQUENT_BY_LEADING_VALUE_DISTANCE_IMMEDIAELY := DINT#4,
            /// Direct synchronous setting at the end of the cam.
            DIRECT_AT_CAM_END := DINT#5,
            /// Synchronization in advance using leading value distance starting from current leading value position.
            IN_ADVANCE_BY_LEADING_VALUE_DISTANCE_IMMEDIATELY := DINT#6,
            /// Direct synchronous setting at specific leading value position.
            DIRECT_AT_LEADING_SYNC_POSITION := DINT#7
        ) := IN_ADVANCE_BY_LEADING_VALUE_DISTANCE;
    END_TYPE
END_NAMESPACE
