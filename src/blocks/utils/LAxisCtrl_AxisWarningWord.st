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
    /// Functionality: The FB is splitting the warning word of an axis (DB_Any) into bits.
    ///================================================================================
    FUNCTION_BLOCK AxisWarningWord
        {S7.Extern = ReadWrite}
        VAR_INPUT
            // Axis specification
            axis : DB_ANY;
        END_VAR

        {S7.Extern = ReadOnly}
        VAR_OUTPUT
            /// Status of FB
            status : WORD;
            /// WarningWord of axis
            warningWord : DWORD;
            /// TRUE: A system-internal error has occurred
            systemWarning : BOOL;
            /// TRUE: Configuration error (One or several configuration parameters are adjusted internally)
            configWarning : BOOL;
            /// TRUE: Error in user program at a Motion Control instruction or its use
            userWarning : BOOL;
            /// TRUE: Job cannot be executed. A Motion Control instruction cannot be executed because the necessary conditions have not been met
            commandNotAccepted : BOOL;
            /// TRUE: Warning of the drive. When a warning message is pending at the drive that does not result in a TO alarm, this bit is not set. Evaluate the drive warnings directly using the status word of the drive
            driveWarning : BOOL;
            /// TRUE: Error in encoder system
            sensorWarning : BOOL;
            /// TRUE: Specified dynamic values are limited to permissible values
            dynamicError : BOOL;
            /// TRUE: Communication error (Missing or faulty communication)
            communicationWarning : BOOL;
            /// TRUE: The negative software limit switch has been approached
            swLimitMin : BOOL;
            /// TRUE: The positive software limit switch has been approached
            swLimitMax : BOOL;
            /// TRUE: Error during homing operation (The homing cannot be completed)
            homingWarning : BOOL;
            /// TRUE: Warning limit of following error monitoring reached/exceeded
            followingErrorWarning : BOOL;
            /// TRUE: Positioning error
            positioningWarning : BOOL;
            /// TRUE: Error accessing a logical address
            peripheralWarning : BOOL;
            /// TRUE: Error during synchronous operation (The leading axis specified in the Motion Control instruction was not configured as a possible leading axis)
            synchronousWarning : BOOL;
            /// TRUE: Error in automatic data transfer
            adaptionWarning : BOOL;
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
            /// Temporary warningWord
            tempWarningWord : DWORD;
        END_VAR

        VAR CONSTANT
            // Illegal specification of the technology object. Check the specification of the technology object for the "Axis", "Master" or "Cam" parameter.
            ERROR_INVALID_TECHNOLOGY_OBJECT : WORD := WORD#16#8002;
            // FB Finished
            FINISHED : WORD := WORD#16#0000;
        END_VAR

        // cache references of speed axis and external encoder in static memory and only update when input changes
        IF (axis <> UINT#0 AND axis <> _axisOld) THEN
            _refSpeedAxis := AsSpeedAxisRef(axis);
            _refExtEncoder := AsExternalEncoderRef(axis);
        END_IF;

        // Axis type is TO_SpeedAxis or TO_PositioningAxis or TO_SynchronousAxis
        IF (_refSpeedAxis <> NULL) THEN
            tempWarningWord := _refSpeedAxis^.WarningWord;
            status := FINISHED;

        // Axis type is TO_ExternalEncoder
        ELSIF (_refExtEncoder <> NULL) THEN
            tempWarningWord := _refExtEncoder^.WarningWord;
            status := FINISHED;

        // Invalid TO specification
        ELSE
            status := ERROR_INVALID_TECHNOLOGY_OBJECT;
        END_IF;

        warningWord := tempWarningWord;

        systemWarning := tempWarningWord.%X0;
        configWarning := tempWarningWord.%X1;
        userWarning := tempWarningWord.%X2;
        commandNotAccepted := tempWarningWord.%X3;
        driveWarning := tempWarningWord.%X4;
        sensorWarning := tempWarningWord.%X5;
        dynamicError := tempWarningWord.%X6;
        communicationWarning := tempWarningWord.%X7;
        swLimitMin := tempWarningWord.%X8;
        swLimitMax := tempWarningWord.%X9;
        homingWarning := tempWarningWord.%X10;
        followingErrorWarning := tempWarningWord.%X11;
        positioningWarning := tempWarningWord.%X12;
        peripheralWarning := tempWarningWord.%X13;
        synchronousWarning := tempWarningWord.%X14;
        adaptionWarning := tempWarningWord.%X15;
    END_FUNCTION_BLOCK
END_NAMESPACE
