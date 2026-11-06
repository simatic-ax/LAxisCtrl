NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeHoming : STRUCT
            /// The specified value is used according to the selected "Mode"
            position : LREAL := 0.0;
            /// Operation mode; 0: Direct homing (absolute); 1: Direct homing (relative); 2: Passive homing (without reset); 3: Active homing; 5: Active homing (Position parameter has no effect); 6: Absolute encoder adjustment (relative); 7: Absolute encoder adjustment (absolute); 8: Passive homing; 9: Abort passive homing; 10: Passive homing (Position parameter has no effect); 11: Set setpoINT position (absolute); 12: Shift the setpoINT position (relative); 13: Incremental encoder adjustment
            mode : HomingMode;
            /// Only relevant for S7-1500T: Selection of the absolute encoder ("Mode" = 6, 7) or incremental encoder ("Mode" = 13) to be calibrated; 0: Operative encoder; 1..4: Encoder 1..4 (S7-1500T)
            sensor : HomingSensor;
            /// -1: No extended homing mode (parameter "mode" is effective); 0: Homing on fixed stop; 1: Homing on fixed stop with moving out of clamping; 2: Homing on fixed stop with moving to target position
            extendedMode : HomingExtendedMode;
            /// Value of the torque/force for extended homing mode
            extendedModeTorqueLimit : LREAL := 0.0;
            /// Target position when 'extendedMode' = 2
            extendedModeTargetPosition : LREAL := 0.0;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
