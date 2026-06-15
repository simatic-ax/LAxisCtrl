NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeCamIn : STRUCT
            /// Offset of the leading values of the cam (The cam technology object is not changed) when "SyncProfileReference" = 0, 1, 3, 4, 7
            masterOffset : LREAL := 0.0;
            /// Offset of the following values of the cam (The cam technology object is not changed) when "SyncProfileReference" = 0, 1, 3, 4, 6
            slaveOffset : LREAL := 0.0;
            /// Scaling the leading values of the cam
            masterScaling : LREAL := 1.0;
            /// Scaling the following values of the cam
            slaveScaling : LREAL := 1.0;
            /// Position of the leading axis (relative to the start position of the cam), from which the axes are synchronous and synchronization is complete (The value must be within the definition of the cam) when "SyncProfileReference" = 0, 1, 6. Position of the leading axis (relative to the start position of the cam) from which the synchronization begins (The value must be within the definition of the cam) when "SyncProfileReference" = 3. Position of the leading axis (relative to the start position of the cam to be changed), from which the axes are synchronous (The value must be within the definition of the cam to be changed) when "SyncProfileReference" = 2, 5, 7
            masterSyncPosition : LREAL := 0.0;
            /// Position of the leading axis (relative to the start position of the cam), from which the axes are synchronous and synchronization is complete (The value must be within the definition of the cam) when "SyncProfileReference" = 0, 1, 6. Position of the leading axis (relative to the start position of the cam) from which the synchronization begins (The value must be within the definition of the cam) when "SyncProfileReference" = 3. Position of the leading axis (relative to the start position of the cam to be changed), from which the axes are synchronous (The value must be within the definition of the cam to be changed) when "SyncProfileReference" = 2, 5, 7
            syncProfileReference : CamInSyncProfileReference;
            /// Leading value distance when "SyncProfileReference" = 1, 3, 4, 6
            masterStartDistance : LREAL := 0.0;
            /// Velocity for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            velocity : LREAL := -1.0;
            /// Acceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            acceleration : LREAL := -1.0;
            /// Deceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            deceleration : LREAL := -1.0;
            /// Jerk for synchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            jerk : LREAL := -1.0;
            /// Application of the cam (0: Once/not cyclic; 1: Cyclic (absolute application on the following value side); 2: Cyclic appending (continuously appending on the following value side))
            applicationMode : CamInApplicationMode;
            /// Direction for synchronization only in effect for axes with activated modulo setting (1: Forward direction; 2: Backward direction; 3: Shortest way) when "SyncProfileReference" = 0, 1, 3, 4, 6
            syncDirection : CamInSyncDirection := CamInSyncDirection#POSITIVE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
