NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PowerSyncMotionSimulationExtended : DINT (
            /// Start the simulation of synchronous operation only if the axis is in synchronous operation
            START_SIM_IN_SYNC_OP := -1,
            /// Start the simulation of synchronous operation independently from the synchronous operation state
            START_SIM_DIRECT := 0
        ) := START_SIM_IN_SYNC_OP;
    END_TYPE
END_NAMESPACE
