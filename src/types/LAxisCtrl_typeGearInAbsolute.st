NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeGearInAbsolute : STRUCT
            /// Gear ratio numerator (permitted integer values: -2147483648 to 2147483647; value 0 not permitted)
            ratioNumerator : DINT := 1;
            /// Gear ratio denominator (permitted integer values: 1 to 2147483647)
            ratioDenominator : DINT := 1;
            /// Synchronous position of leading axis
            masterSyncPosition : LREAL := 0.0;
            /// Synchronous position of following axis
            slaveSyncPosition : LREAL := 0.0;
            /// Type of synchronization (0: Synchronization in advance using dynamic parameters; 1: Synchronization in advance using leading value distance; 3: Subsequent synchronization using leading value distance; 4: Subsequent synchronization using leading value distance starting from current leading value position with calculated synchronous position of the following axis; 5: Subsequent synchronization using leading value distance with calculated synchronous position of the following axis)
            syncProfileReference : GearInAbsoluteSyncProfileReference;
            /// Leading value distance when "SyncProfileReference" = 1, 3, 4, 5
            masterStartDistance : LREAL := 0.0;
            /// Velocity for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object) when "SyncProfileReference" = 0
            velocity : LREAL := -1.0;
            /// Acceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)  when "SyncProfileReference" = 0
            acceleration : LREAL := -1.0;
            /// Deceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)  when "SyncProfileReference" = 0
            deceleration : LREAL := -1.0;
            /// Jerk for synchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)  when "SyncProfileReference" = 0
            jerk : LREAL := -1.0;
            /// Direction for synchronization only in effect for axes with activated modulo setting (1: Forward direction; 2: Backward direction; 3: Shortest way)
            syncDirection : GearInAbsoluteSyncDirection := GearInAbsoluteSyncDirection#POSITIVE;
            /// TRUE: Changing gear ratio on-the-fly while the command is active and the corresponding input is set; FALSE: Ratio change requires a new rising edge at gearInAbsolute input
            ratioChangeOnTheFly : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
