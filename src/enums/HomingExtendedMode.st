NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        HomingExtendedMode : DINT (
            /// No extended homing mode (parameter "mode" is effective)
            INACTIVE := -1,
            /// Homing on fixed stop
            HOMING_ON_FIXED_STOP := 0,
            /// Homing on fixed stop with moving out of clamping
            HOMING_ON_FIXED_STOP_MOVING_OUT_OF_CLAMPING := 1,
            /// Homing on fixed stop with moving to target position
            HOMING_ON_FIXED_STOP_TO_TARGET_POSITION := 2
        ) := INACTIVE;
    END_TYPE
END_NAMESPACE
