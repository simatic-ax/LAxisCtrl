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
    /// Functionality: The FB is splitting the error word of an axis (DB_Any) into bits.
    ///================================================================================
    FUNCTION_BLOCK AxisErrorWord
        {S7.Extern = ReadWrite}
        VAR_INPUT
            // Axis specification
            axis : DB_ANY;
        END_VAR

        {S7.Extern = ReadOnly}
        VAR_OUTPUT
            /// Status of FB
            status : WORD;
            /// ErrorWord of axis
            errorWord : DWORD;
            /// TRUE: System fault (A system-internal error has occurred)
            systemFault : BOOL;
            /// TRUE: Configuration error (One or more configuration parameters are inconsistent or invalid)
            configFault : BOOL;
            /// TRUE: User fault (Error in user program at a Motion Control instruction or its use)
            userFault : BOOL;
            /// TRUE: Job cannot be executed. A Motion Control instruction cannot be executed because the necessary conditions have not been met
            commandNotAccepted : BOOL;
            /// TRUE: Error in drive
            driveFault : BOOL;
            /// TRUE: Error in encoder system
            sensorFault : BOOL;
            /// TRUE: Specified dynamic values are limited to permissible values
            dynamicError : BOOL;
            /// TRUE: Communication error (Missing or faulty communication)
            communicationFault : BOOL;
            /// TRUE: Software limit switch reached or overtraveled
            swLimit : BOOL;
            /// TRUE: Hardware limit switch reached or overtraveled
            hwLimit : BOOL;
            /// TRUE: Error during homing operation (The homing cannot be completed)
            homingError : BOOL;
            /// TRUE: Following error limits exceeded
            followingErrorFault : BOOL;
            /// TRUE: Positioning error
            positioningFault : BOOL;
            /// TRUE: Error accessing a logical address
            peripheralError : BOOL;
            /// TRUE: Error during synchronous operation (The leading axis specified in the Motion Control instruction was not configured as a possible leading axis)
            synchronousError : BOOL;
            /// TRUE: Error in automatic data transfer
            adaptionError : BOOL;
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
            /// Temporary errorWord
            tempErrorWord : DWORD;
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

        _axisOld := axis;

        // Axis type is TO_SpeedAxis or TO_PositioningAxis or TO_SynchronousAxis
        IF (_refSpeedAxis <> NULL) THEN
            tempErrorWord := _refSpeedAxis^.ErrorWord;
            status := FINISHED;

        // Axis type is TO_ExternalEncoder
        ELSIF (_refExtEncoder <> NULL) THEN
            tempErrorWord := _refExtEncoder^.ErrorWord;
            status := FINISHED;

        // Invalid TO specification
        ELSE
            status := ERROR_INVALID_TECHNOLOGY_OBJECT;
        END_IF;

        errorWord := tempErrorWord;

        systemFault := tempErrorWord.%X0;
        configFault := tempErrorWord.%X1;
        userFault := tempErrorWord.%X2;
        commandNotAccepted := tempErrorWord.%X3;
        driveFault := tempErrorWord.%X4;
        sensorFault := tempErrorWord.%X5;
        dynamicError := tempErrorWord.%X6;
        communicationFault := tempErrorWord.%X7;
        swLimit := tempErrorWord.%X8;
        hwLimit := tempErrorWord.%X9;
        homingError := tempErrorWord.%X10;
        followingErrorFault := tempErrorWord.%X11;
        positioningFault := tempErrorWord.%X12;
        peripheralError := tempErrorWord.%X13;
        synchronousError := tempErrorWord.%X14;
        adaptionError := tempErrorWord.%X15;
    END_FUNCTION_BLOCK
END_NAMESPACE
