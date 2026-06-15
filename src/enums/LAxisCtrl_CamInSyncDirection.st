NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        CamInSyncDirection : DINT (
            /// Positive direction The following axis may only travel in positive direction during synchronization.
            POSITIVE := 1,
            /// Negative direction The following axis may only travel in negative direction during synchronization.
            NEGATIVE := 2,
            /// Shortest distance Changes in direction are permitted for the following axis during synchronization
            SHORTEST_DIST := 3
        ) := SHORTEST_DIST;
    END_TYPE
END_NAMESPACE
