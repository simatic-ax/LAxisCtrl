NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        PowerSyncMotionSimulationExtended : DINT (
            /// Start the simulation of synchronous operation only if the axis is in synchronous operation
            START_SIMULATION_IN_SYNCHRONOUS_OPERATION := -1,
            /// Start the simulation of synchronous operation independently from the synchronous operation state
            START_SIMULATION_DIRECT := 0
        ) := START_SIMULATION_IN_SYNCHRONOUS_OPERATION;
    END_TYPE
END_NAMESPACE
