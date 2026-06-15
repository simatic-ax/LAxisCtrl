USING Siemens.Simatic.MotionControl.Native;

NAMESPACE Simatic.Ax.LAxisCtrl
    ///================================================================================
    /// SIEMENS AG
    /// (c)Copyright 2026 All Rights Reserved
    ///--------------------------------------------------------------------------------
    /// Library: LAxisCtrl
    /// Engineering: SIMATIC AX
    /// Restrictions: -
    /// Requirements: S7-1500 FW 3.1
    /// Functionality: The function is splitting the status word of an axis (DB_Any) into bits.
    ///================================================================================
    FUNCTION_BLOCK AxisStatusWord
        {S7.Extern = ReadWrite}
        VAR_INPUT
            /// Axis specification
            axis : DB_ANY;
        END_VAR

        {S7.Extern = ReadOnly}
        VAR_OUTPUT
            /// Status of FB
            status : WORD;
            /// StatusWord of axis
            statusWord : DWORD;
            /// StatusWord2 of axis
            statusWord2 : DWORD;
            /// TRUE: The technology object has been enabled
            enable : BOOL;
            /// TRUE: An error is present
            error : BOOL;
            /// TRUE: A restart is active. The technology object is being reinitialized
            restartActive : BOOL;
            /// TRUE: The restart tags have been changed. For the changes to be applied, the technology object must be reinitialized
            onlineStartValuesChanged : BOOL;
            /// TRUE: The axis control panel is active
            controlPanelActive : BOOL;
            /// TRUE: The technology object is homed
            homingDone : BOOL;
            /// TRUE: No motion job is in progress and the axis control panel is deactivated
            done : BOOL;
            /// TRUE: The axis is at a standstill
            standstill : BOOL;
            /// TRUE: A positioning command is active ("MC_MoveRelative", "MC_MoveAbsolute")
            positioningCommand : BOOL;
            /// TRUE: An "MC_MoveJog" job is running
            jogCommand : BOOL;
            /// TRUE: An "MC_MoveVelocity" job is running
            velocityCommand : BOOL;
            /// TRUE: An "MC_Home" job is being processed
            homingCommand : BOOL;
            /// TRUE: The velocity setpoint is reached. A constant velocity setpoint is output
            constantVelocity : BOOL;
            /// TRUE: An acceleration operation is active
            accelerating : BOOL;
            /// TRUE: A deceleration operation is active
            decelerating : BOOL;
            /// TRUE: A negative software limit switch has been approached or exceeded
            swLimitMinActive : BOOL;
            /// TRUE: A positive software limit switch has been approached or exceeded
            swLimitMaxActive : BOOL;
            /// TRUE: A negative hardware limit switch has been approached or exceeded
            hwLimitMinActive : BOOL;
            /// TRUE: A positive hardware limit switch has been approached or exceeded
            hwLimitMaxActive : BOOL;
            /// TRUE: The axis synchronizes to a leading value
            synchronizing : BOOL;
            /// TRUE: The axis moves synchronously to a leading value
            synchronous : BOOL;
            /// TRUE: An "MC_MoveSuperimposed" job is running
            superimposedMotionCommand : BOOL;
            /// TRUE: An "MC_PhasingAbsolute" or "MC_PhasingRelative" job for the leading value shift is active
            phasingCommand : BOOL;
            /// TRUE: The technology object is in simulation
            axisSimulation : BOOL;
            /// TRUE: An "MC_TorqueLimiting" job is running
            torqueLimitingCommand : BOOL;
            /// TRUE: The drive operates at least at the threshold value (default 90%) of the torque limit/force limitation
            inLimitation : BOOL;
            /// TRUE: The axis is not in position-controlled mode
            nonPositionControlled : BOOL;
            /// TRUE: The axis is used for a kinematics job
            kinematicsMotionCommand : BOOL;
            /// TRUE: The axis is clamped at a fixed stop
            inClamping : BOOL;
            /// TRUE: An "MC_MotionIn" job is active
            motionInCommand : BOOL;
            /// TRUE: An "MC_Stop" job is running. The technology object is locked
            stopCommand : BOOL;
            /// TRUE: An "MC_GearOut" job or "MC_CamOut" job is active. The following axis is desynchronized
            desynchronizingCommand : BOOL;
            /// TRUE: The backlash is traversed. <TO>.ActualPosition does not hereby change
            passingBacklash : BOOL;
            /// TRUE: An "MC_PhasingAbsolute" or "MC_PhasingRelative" job for leading value shift is waiting
            phasingCommandWaiting : BOOL;
            /// TRUE: An "MC_OffsetAbsolute" or "MC_OffsetRelative" job for following value offset is active
            offsetCommand : BOOL;
            /// TRUE: An "MC_OffsetAbsolute" or "MC_OffsetRelative" job for following value offset is waiting
            offsetCommandWaiting : BOOL;
            /// TRUE: An "MC_MotionInSuperimposed" job is running
            motionInSuperimposedCommand : BOOL;
            /// TRUE: An "MC_HaltSuperimposed" job is running
            haltSuperimposedCommand : BOOL;
        END_VAR

        VAR
            /// Internal old value for axis
            _axisOld : DB_ANY;
            /// Internal reference of the technology object type TO_SpeedAxis
            _refSpeedAxis : REF_TO TO_SpeedAxis;
            /// Internal reference of the technology object type TO_ExternalEncoder
            _refExtEncoder : REF_TO TO_ExternalEncoder;
        END_VAR

        VAR_TEMP
            /// Temporary statusWord
            tempStatusWord : DWORD;
            // Temporary statusWord2
            tempStatusWord2 : DWORD;

        END_VAR

        VAR CONSTANT
            /// Illegal specification of the technology object. Check the specification of the technology object for the "Axis", "Master" or "Cam" parameter.
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
            /// FB Finished
            FINISHED : WORD := WORD#16#0000;
        END_VAR

        // cache references of speed axis and external encoder in static memory and only update when input changes
        IF (axis <> UINT#0 AND axis <> _axisOld) THEN
            _refSpeedAxis := AsSpeedAxisRef(axis);
            _refExtEncoder := AsExternalEncoderRef(axis);
        END_IF;

        _axisOld := axis;

        // Axis type is TO_SpeedAxis or TO_PositioningAxis or TO_SynchronousAxis
        IF (_refSpeedAxis <> NULL) THEN
            tempStatusWord := _refSpeedAxis^.StatusWord;
            tempStatusWord2 := _refSpeedAxis^.StatusWord2;
            status := FINISHED;

        // Axis type is TO_ExternalEncoder
        ELSIF (_refExtEncoder <> NULL) THEN
            tempStatusWord := _refExtEncoder^.StatusWord;
            status := FINISHED;

        // Invalid TO specification
        ELSE
            status := ERROR_INVALID_TECHNOLOGY_OBJECT;
        END_IF;

        statusWord := tempStatusWord;
        statusWord2 := tempStatusWord2;

        enable := tempStatusWord.%X0;
        error := tempStatusWord.%X1;
        restartActive := tempStatusWord.%X2;
        onlineStartValuesChanged := tempStatusWord.%X3;
        controlPanelActive := tempStatusWord.%X4;
        homingDone := tempStatusWord.%X5;
        done := tempStatusWord.%X6;
        standstill := tempStatusWord.%X7;
        positioningCommand := tempStatusWord.%X8;
        jogCommand := tempStatusWord.%X9;
        velocityCommand := tempStatusWord.%X10;
        homingCommand := tempStatusWord.%X11;
        constantVelocity := tempStatusWord.%X12;
        accelerating := tempStatusWord.%X13;
        decelerating := tempStatusWord.%X14;
        swLimitMinActive := tempStatusWord.%X15;
        swLimitMaxActive := tempStatusWord.%X16;
        hwLimitMinActive := tempStatusWord.%X17;
        hwLimitMaxActive := tempStatusWord.%X18;
        synchronizing := tempStatusWord.%X21;
        synchronous := tempStatusWord.%X22;
        superimposedMotionCommand := tempStatusWord.%X23;
        phasingCommand := tempStatusWord.%X24;
        axisSimulation := tempStatusWord.%X25;
        torqueLimitingCommand := tempStatusWord.%X26;
        inLimitation := tempStatusWord.%X27;
        nonPositionControlled := tempStatusWord.%X28;
        kinematicsMotionCommand := tempStatusWord.%X29; // V15
        inClamping := tempStatusWord.%X30;
        motionInCommand := tempStatusWord.%X31; // V15

        stopCommand := tempStatusWord2.%X0; // V16

        desynchronizingCommand := tempStatusWord2.%X1; // V17
        passingBacklash := tempStatusWord2.%X2; // V17
        phasingCommandWaiting := tempStatusWord2.%X3; // V17
        offsetCommand := tempStatusWord2.%X4; // V17
        offsetCommandWaiting := tempStatusWord2.%X5; // V17

        motionInSuperimposedCommand := tempStatusWord2.%X6; // V18
        haltSuperimposedCommand := tempStatusWord2.%X7; // V18
    END_FUNCTION_BLOCK
END_NAMESPACE
