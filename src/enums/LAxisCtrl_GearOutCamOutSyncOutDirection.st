NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        GearOutCamOutSyncOutDirection : DINT (
            /// Positive direction The following axis may only travel in positive direction during desynchronization.
            POSITIVE := 1,
            /// Negative direction The following axis may only travel in negative direction during desynchronization.
            NEGATIVE := 2,
            /// Current direction The following axis is desynchronized in the direction in which the following axis is currently traveling.
            CURRENT := 3
        ) := CURRENT;
    END_TYPE
END_NAMESPACE
