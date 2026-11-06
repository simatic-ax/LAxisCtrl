NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Direction of an following axis when desynchronizing from a gearing or camming operation.
        DirectionSyncOut : DINT (
            /// Following axis moves in a positive direction during desynchronization.
            POSITIVE := DINT#1,
            /// Following axis moves in a negative direction during desynchronization.
            NEGATIVE := DINT#2,
            /// Following axis moves keeps direction during desynchronization.
            CURRENT := DINT#3
        ) := POSITIVE;
    END_TYPE
END_NAMESPACE
