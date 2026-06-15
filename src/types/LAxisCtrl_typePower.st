NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typePower : STRUCT
            /// 0: Enable axis not position-controlled; 1: Enable axis position-controlled (This parameter is ignored when a speed axis or external encoder is used)
            startMode : PowerStartMode;
            /// 0: Emergency stop; 1: Immediate stop; 2: Stop with maximum dynamic values; 3: Coasting down
            stopMode : PowerStopMode;
            /// TRUE: Start the simulation of synchronous operation automatically with falling edge at enableAxis; FALSE: No simulation of synchronous operation
            syncMotionSimulation : BOOL := FALSE;
            /// Only valid if 'syncMotionSimulation' = TRUE: -1: Start the simulation of synchronous operation only if the axis is in synchronous operation; 0: Start the simulation of synchronous operation independently from the synchronous operation state
            syncMotionSimulationExtendedMode : PowerSyncMotionSimulationExtended;
            /// TRUE: MC_POWER instance is not called, i.e. the axis can be powered on via an externally called MC_POWER instance. Note: The config flag is directly taken INTo account. The user is responsible for a consistent changeover. The input 'enableAxis' is not effective. The status of the output 'axisEnabled' is generated via StatusWord Bit 0 and not via MC_Power.STATUS and .BUSY information. The 'syncMotionSimulation' functionality is not working
            externalMC_PowerCall : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
