NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeGearOutCamOut : STRUCT
            /// Stop position of following axis
            slavePosition : LREAL := 0.0;
            /// Type of desynchronization (0: Desynchronize using dynamic behavior; 1: Desynchronize using leading value distance; 5: Cancel only a pending gearing / camming)
            syncProfileReference : GearOutCamOutSyncProfileReference;
            /// Leading value distance when "SyncProfileReference" = 1
            masterStopDistance : LREAL := 0.0;
            /// Deceleration for desynchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            deceleration : LREAL := -1.0;
            /// Jerk for desynchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoidal velocity profile; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            jerk : LREAL := -1.0;
            /// Desynchronization direction (1: Positive direction; 2: Negative direction; 3: Current direction)
            syncOutDirection : GearOutCamOutSyncOutDirection;
            /// -1: Automatic detection whether to use a MC_GearOut or MC_CamOut; 0: Use of MC_GearOut; 1: Use of MC_CamOut
            gearOutCamOutMode : GearOutCamOutMode;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
