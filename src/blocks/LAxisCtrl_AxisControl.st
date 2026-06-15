USING System.Math;
USING Siemens.Simatic.MotionControl.Native;

NAMESPACE Simatic.Ax.LAxisCtrl
    ///================================================================================
    /// SIEMENS AG
    /// (c)Copyright 2026 All Rights Reserved
    ///--------------------------------------------------------------------------------
    /// Library: LAxisCtrl
    /// Engineering: SIMATIC AX
    /// Restrictions: -
    /// Requirements: S7-1500T FW 4.0
    /// Functionality: This function block offers basic functionalities for axis control
    ///================================================================================
    FUNCTION_BLOCK AxisControl
        {S7.Extern = ReadWrite}
        VAR_INPUT
            /// TRUE: Enable functionality of FB
            enable : BOOL := FALSE;
            /// TRUE: Set axis enable; FALSE: Remove axis enable. MC_Power is used internally
            enableAxis : BOOL := FALSE;
            /// Rising edge: Acknowledgment of technology alarms or restart of the axis (depending on config). MC_Reset is used internally
            resetAxis : BOOL := FALSE;
            /// TRUE: Unconditionally open holding brake if axis is not enabled (e.g. for service purposes). Note: Do not modify this input while disabling of the axis is active (input enableAxis := FALSE and output axisEnabled = TRUE). MC_SetAxisSTW is used internally
            openBrake : BOOL := FALSE;
            /// Rising edge: Move an axis in jog mode (forward); Falling edge: Stop jogging. MC_MoveJog is used internally
            jogForward : BOOL := FALSE;
            /// Rising edge: Move an axis in jog mode (backward); Falling edge: Stop jogging. MC_MoveJog is used internally
            jogBackward : BOOL := FALSE;
            /// Rising edge: Move an axis at constant velocity/speed. MC_MoveVelocity is used internally
            moveVelocity : BOOL := FALSE;
            /// Rising edge: Brake an axis until it comes to a standstill. Note: MC_Halt is triggered internally
            stop : BOOL := FALSE;
            /// Rising edge: Brake an axis until it comes to a standstill (with fastStop dynamics). Note: MC_Halt is triggered internally
            fastStop : BOOL := FALSE;
            /// TRUE: Enable force/torque limiting. MC_TorqueLimiting is used internally
            torqueLimiting : BOOL := FALSE;
            /// Rising edge: Home axis. MC_Home is used internally
            homing : BOOL := FALSE;
            /// Rising edge: Move an axis relative to its position when execution of the job began. MC_MoveRelative is used internally
            posRelative : BOOL := FALSE;
            /// Rising edge: Move an axis to an absolute position. MC_MoveAbsolute is used internally
            posAbsolute : BOOL := FALSE;
            /// Rising edge: Start a superimposed positioning. MC_MoveSuperimposed is used internally
            posSuperimposed : BOOL := FALSE;
            /// Rising edge: Decelerate a superimposed motion to zero velocity. MC_HaltSuperimposed is used internally
            haltSuperimposed : BOOL := FALSE;
            /// Rising edge: Start a gearing operation (relative). MC_GearIn is used internally
            gearInRelative : BOOL := FALSE;
            /// Rising edge: Start a gearing operation (absolute). MC_GearInPos is used internally
            gearInAbsolute : BOOL := FALSE;
            /// Rising edge: Start a gearing operation (velocity synchronous). MC_GearInVelocity is used internally
            gearInVelocity : BOOL := FALSE;
            /// Rising edge: End a gearing/camming operation. MC_GearOut/MC_CamOut is used internally
            gearOutCamOut : BOOL := FALSE;
            /// Rising edge: Start a camming operation. MC_CamIn is used internally
            camIn : BOOL := FALSE;
            /// Rising edge: Start a phasing operation. MC_PhasingRelative/MC_PhasingAbsolute is used internally
            phasing : BOOL := FALSE;
            /// Rising edge: Start an offset operation. MC_OffsetRelative/MC_OffsetAbsolute is used internally
            offset : BOOL := FALSE;
            /// Reference to axis technology object to be controlled
            axis : DB_ANY  := UINT#0;
            /// Reference to leading axis technology object for synchronous motion
            master : DB_ANY := UINT#0;
            /// Cam technology object
            cam : DB_ANY := UINT#0;
            /// Structure for parameters
            config : typeAxisConfig;
        END_VAR

        {S7.Extern = ReadOnly}
        VAR_OUTPUT
            /// TRUE: Valid set of output values available at the FB
            valid : BOOL := FALSE;
            /// TRUE: FB is working and new output values can be expected
            busy : BOOL := FALSE;
            /// TRUE: An error occurred while processing the FB
            error : BOOL := FALSE;
            /// Current status of FB (16#0000 - 16#7FFF: Status of the FB, 16#8000 - 16#FFFF: Error identification)
            status : AxisStatus;
            /// Text of current status of FB
            statusText : String[STATUS_TEXT_LENGTH] := STRING#'STATUS_NO_CALL';
            /// Status of internally called subfunctions (ErrorID of Motion Control instructions)
            subfunctionStatus : WORD;
            /// TRUE: The technology object is enabled. Motion commands can be executed
            axisEnabled : BOOL := FALSE;
            /// TRUE: Reset/Restart of the axis is active
            resetActive : BOOL := FALSE;
            /// TRUE: The selected basic motion command is being executed
            commandBusy : BOOL := FALSE;
            /// TRUE: The selected basic motion command has completed without error
            commandDone : BOOL := FALSE;
            /// TRUE: The selected basic motion command has been aborted
            commandAborted : BOOL := FALSE;
            /// TRUE: The setpoint velocity/speed was reached and will be maintained
            inVelocity : BOOL := FALSE;
            /// TRUE: The drive is operating at the force/torque limit
            inLimitation : BOOL := FALSE;
            /// TRUE: Homing command is being executed
            homingCommandBusy : BOOL := FALSE;
            /// TRUE: Homing command has completed without error
            homingCommandDone : BOOL := FALSE;
            /// TRUE: Homing command has been aborted
            homingCommandAborted : BOOL := FALSE;
            /// TRUE: The selected superimposed motion command is being executed
            superimposedBusy : BOOL := FALSE;
            /// TRUE: The selected superimposed motion command  has completed without error
            superimposedDone : BOOL := FALSE;
            /// TRUE: The selected superimposed motion command has been aborted
            superimposedAborted : BOOL := FALSE;
            /// TRUE: The selected superimposed motion is active
            superimposedStart : BOOL := FALSE;
            /// TRUE: The drive is kept at the fixed stop (clamping), the axis position is within the positioning tolerance
            inClamping : BOOL := FALSE;
            /// TRUE: The axis is synchronizing to the leading axis / desynchronizing from the leading axis (Note: signal is only valid for the currently selected synchronous functionality, see outputs 'gearInAbsoluteSelected', 'gearInVelocitySelected', 'gearOutCamOutSelected' or 'camInSelected')
            startSync : BOOL := FALSE;
            /// TRUE: The axis is synchronized to the leading axis (Note: signal is only valid for the currently selected synchronous functionality, see outputs 'gearInRelativeSelected', 'gearInAbsoluteSelected', 'gearInVelocitySelected' or 'camInSelected')
            inSync : BOOL := FALSE;
            /// TRUE: The end of the cam has been reached. The output is displayed for at least one call when the cam is used cyclically
            endOfProfile : BOOL := FALSE;
            /// TRUE: Synchronous operation is being simulated
            inSimulation : BOOL := FALSE;
            /// TRUE: Jogging is active
            jogSelected : BOOL := FALSE;
            /// TRUE: Moving with constant velocity/speed is active
            moveVelocitySelected : BOOL := FALSE;
            /// TRUE: Stopping is active
            stopSelected : BOOL := FALSE;
            /// TRUE: Stopping is active (with fastStop dynamics)
            fastStopSelected : BOOL := FALSE;
            /// TRUE: Force/Torque limiting is active
            torqueLimitingSelected : BOOL := FALSE;
            /// TRUE: Homing is active
            homingSelected : BOOL := FALSE;
            /// TRUE: Relative positioning is active
            posRelativeSelected : BOOL := FALSE;
            /// TRUE: Absolute positioning is active
            posAbsoluteSelected : BOOL := FALSE;
            /// TRUE: Superimposed positioning is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted)
            posSuperimposedSelected : BOOL := FALSE;
            /// TRUE: Superimposed halting is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted)
            haltSuperimposedSelected : BOOL := FALSE;
            /// TRUE: Relative gearing is active (See also outputs: commandBusy, commandDone, commandAborted, inSync)
            gearInRelativeSelected : BOOL := FALSE;
            /// TRUE: Absolute gearing is active (See also outputs: commandBusy, commandDone, commandAborted, startSync, inSync)
            gearInAbsoluteSelected : BOOL := FALSE;
            /// TRUE: Velocity gearing is active (See also outputs: commandBusy, commandDone, commandAborted, startSync, inSync)
            gearInVelocitySelected : BOOL := FALSE;
            /// TRUE: End a gearing/camming operation is active (See also outputs: commandBusy, commandDone, commandAborted, startSync)
            gearOutCamOutSelected : BOOL := FALSE;
            /// TRUE: Camming is active (See also outputs: commandBusy, commandDone, commandAborted, startSync, inSync)
            camInSelected : BOOL := FALSE;
            /// TRUE: Phasing is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted, superimposedStart)
            phasingSelected : BOOL := FALSE;
            /// TRUE: Offset is active (See also outputs: superimposedBusy, superimposedDone, superimposedAborted, superimposedStart)
            offsetSelected : BOOL := FALSE;
            /// Diagnostics structure
            diagnostics : typeDiagnostics;
        END_VAR

        VAR
            /// Old value of statStatus
            _statusOld : AxisStatus;
            /// Internal text of current status of FB
            _statusText : String[STATUS_TEXT_LENGTH] := STRING#'STATUS_NO_CALL';
            /// Error occurred that can only be solved by user; rising edge at enable input necessary
            _errorUserCleared : BOOL := FALSE;
            /// Error occurred that can be acknowledged by FB
            _errorAutoCleared : BOOL := FALSE;
            /// Internal variable for status
            _status : AxisStatus;
            /// Internal variable for subfunction status
            _subfunctionStatus : WORD := WORD#16#0000;
            /// Internal variable for diagnostics
            _diagnostics : typeDiagnostics;
            /// Old value of enable for edge detection
            _enableOld : BOOL := FALSE;
            /// State of FB (function block state machine)
            _state : SINT := AXIS_MOTION;
            /// TRUE: First cycle of reset command
            _firstCycleReset : BOOL := TRUE;
            /// Old value of MC_Power.error
            _powerErrorOld : BOOL := FALSE;
            /// State of reset command
            _resetState : INT := CMD_IDLE;
            /// TRUE: First cycle of error in reset command
            _firstCycleResetError : BOOL := FALSE;
            /// Variable for requested extended command (e.g. resetAxis, torquelimiting, homing)
            _extendedCommand : DWORD := CMD_NO_SELECTION;
            /// Old value of variable for requested extended command
            _extendedCommandOld : DWORD := CMD_NO_SELECTION;
            /// Old value of enableAxis for edge detection
            _enableAxisOld : BOOL := FALSE;
            /// Internal empty diagnostic structure
            _emptyDiagnostics : typeDiagnostics;
            /// Old value of variable for homing command input
            _homingOld : BOOL := FALSE;
            /// TRUE: First cycle in homing command
            _firstCycleHoming : BOOL := TRUE;
            /// Current selected passive homing mode
            _passiveHomingState : DINT := NO_HOMING_ACTIVE;
            /// Current state of execution of homing command
            _exeOfHoming : INT := CMD_BUSY;
            /// Variable for requested basic motion command
            _basicCommand : DWORD := CMD_NO_SELECTION;
            /// Old value of variable for requested basic motion command
            _basicCommandOld : DWORD := CMD_NO_SELECTION;
            /// State of selected basic motion command
            _basicMotionState : DINT := NO_SELECTION;
            /// State of execution of current state of basic motion
            _exeOfBasicMotion : INT := CMD_BUSY;
            /// TRUE: First cycle in respective state for basic motion functionality
            _firstCycleBasicMotion : BOOL := TRUE;
            /// TRUE: applicative error occurred (e.g. invalid direction configured)
            _applicativeBasicMotionError : BOOL := FALSE;
            /// Velocity change on the fly is active
            _velocityChangeOnTheFly : BOOL := FALSE;
            /// Internal variable for velocity
            _basicVelocity : LREAL := 0.0;
            /// Internal variable for acceleration
            _basicAcceleration : LREAL := 0.0;
            /// Internal variable for deceleration
            _basicDeceleration : LREAL := 0.0;
            /// Internal variable for jerk
            _basicJerk : LREAL := 0.0;
            /// TRUE: First cycle of done at fastStop
            _firstCycleDone : BOOL := FALSE;
            /// Current executed state for torquelimiting functionality
            _torqueLimitingState : SINT := NO_TORQUE_LIMITING_ACTIVE;
            /// TRUE: Error at Torquelimiting occurred last cycle
            _torqueLimitingErrorOld : BOOL := FALSE;
            /// Current selected jog mode
            _jogMode : DINT := JOG_MODE_CONTINUOUS;
            /// Internal variable for direction of rotation of the axis
            _direction : INT := SPECIFIED_DIR;
            /// Internal variable for stopOnError function
            _stopWithoutSignalization : BOOL;
            /// Brake is opened
            _brakeOpened : BOOL;
            /// Brake change active
            _brakeChangeActive : BOOL;
            /// Edge detection
            _openBrakeOld : BOOL;
            /// The specified value is used according to the selected "Mode".
            _homingPosition : LREAL := 0.0;
            /// Current subState of execution of homing functionality
            _homingSubState : SINT := HOMING_IDLE;
            /// Current subState of execution of jog incremental functionality
            _incJogSubState : SINT := INC_JOG_IDLE;
            /// Last stored axis position (for incremental jogging)
            _incJogStartPosition : LREAL := 0.0;
            /// Old value of direction of executing incremental jogging
            _incJogDirectionOld : INT := 0;
            /// Jog Incremental: distance of Increment (positive or negative)
            _increment : LREAL := 0.0;
            /// Jog Incremental: current distance to destination position
            _incJogDistance : LREAL := 0.0;
            /// TRUE: First cycle in incremental jogging state (detection of new increment)
            _resetIncJog : BOOL := TRUE;
            /// Internal variable for position
            _position : LREAL := 0.0;
            /// Position change on the fly is active
            _positionChangeOnTheFly : BOOL := FALSE;
            /// Current selected active homing mode
            _activeHomingState : DINT := NO_HOMING_ACTIVE;
            /// Variable for requested superimposed motion command
            _supImpCommand : DWORD := CMD_NO_SELECTION;
            /// Old value of variable for requested superimposed motion command
            _supImpCommandOld : DWORD := CMD_NO_SELECTION;
            /// Current selected superimposed motion functionality
            _supImpMotionState : DINT := NO_SELECTION;
            /// Current state of execution of superimposed basic motion
            _exeOfSupImpMotionState : INT := CMD_BUSY;
            /// TRUE: First cycle in positioning (superimposed) functionality
            _firstCycleSupImpMotion : BOOL := TRUE;
            /// Position setpoint (for posSuperimposed command)
            _supImpMotionPosition : LREAL := 0.0;
            /// TRUE: applicative error occurred (e.g. invalid direction configured)
            _applicativeSupImpMotionError : BOOL := FALSE;
            /// Ratio change on the fly is active
            _ratioChangeOnTheFly : BOOL := FALSE;
            /// Gear ratio numerator
            _ratioNumerator : DINT := 1;
            /// Gear ratio denominator
            _ratioDenominator : DINT := 1;
            /// Phase shift change on the fly is active
            _changePhaseShiftOnTheFly : BOOL := FALSE;
            /// Offset change on the fly is active
            _changeOffsetOnTheFly : BOOL := FALSE;
            /// Relative/Absolute master value shift
            _phaseShift : LREAL := 0.0;
            /// Indicates the type of phase shift (TRUE: The phase shift is taken over as an absolute value; FALSE: The phase shift is added to an existing offset)
            _phaseAbsolute : BOOL := TRUE;
            /// Indicates the type of offset shift (TRUE: The offset shift is taken over as an absolute value; FALSE: The offset shift is added to an existing offset)
            _offsetAbsolute : BOOL := FALSE;
            /// Relative/Absolute offset
            _offsetValue : LREAL := 0.0;
            /// Type of axis
            _typeAxis : INT;
            /// Internal variable for enabling axis
            _enableAxis : BOOL := FALSE;
            /// Current executed state for synchronized motion simulation
            _syncMotionSimulationState : SINT := AXIS_NOT_IN_SIM;
            /// Old value of MC_SynchronizedMotionSimulation.error
            _synchronizedMotionErrorOld : BOOL := FALSE;
            /// Current executed State for execution of basic motion commands or reset of waiting gearing / camming commands
            _mainSelectionState : INT := 0;
            /// Application of cam
            _applicationMode : DINT := 0;
            /// Internal variable for waiting function state
            _waitingFunctionState : DINT := 0;
            /// Internal variable for waiting function state
            _waitingFunctionStateAbortAutomatic : DINT := -1;
            /// Internal variable for function state
            _functionState : DINT := 0;
            /// Internal variable
            _gearAndCamOutMode : DINT := 0;
            /// Internal variable
            _syncOutState : DINT;
            /// Internal old value for cam
            _camOld : DB_ANY;
            /// Internal old value for master
            _masterOld : DB_ANY;
            /// Internal reference of the technology object type TO_CamBase
            _refCamBase : REF_TO TO_CamBase;
            /// Internal reference of the technology object type TO_Axis (for the master axis)
            _refMasterAxis : REF_TO TO_Axis;
            /// Internal reference of the technology object type TO_Axis
            _refAxis : REF_TO TO_Axis;
            /// Internal reference of the technology object type TO_ExternalEncoder
            _refExtEncoder : REF_TO TO_ExternalEncoder;
            /// Internal reference of the technology object type TO_SpeedAxis
            _refSpeedAxis : REF_TO TO_SpeedAxis;
            /// Internal reference of the technology object type TO_PositioningAxis
            _refPosAxis : REF_TO TO_PositioningAxis;
            /// Internal reference of the technology object type TO_SynchronousAxis
            _refSyncAxis : REF_TO TO_SynchronousAxis;
            /// Instance of MC_Power
            _instPower : MC_POWER;
            /// Instance of MC_Reset
            _instReset : MC_RESET;
            /// Instance of MC_Home
            _instHome : MC_HOME;
            /// Instance of MC_Halt
            _instHalt : MC_HALT;
            /// Instance of MC_MoveJog
            _instMoveJog : MC_MOVEJOG;
            /// Instance of MC_TorqueLimiting
            _instTorqueLimiting : MC_TORQUELIMITING;
            /// Instance of MC_MoveVelocity
            _instMoveVelocity : MC_MOVEVELOCITY;
            /// Instance of MC_SetAxisSTW
            _instSetAxisSTW : MC_SETAXISSTW;
            /// Instance of MC_MoveRelative
            _instMoveRelative : MC_MOVERELATIVE;
            /// Instance of MC_MoveAbsolute
            _instMoveAbsolute : MC_MOVEABSOLUTE;
            /// Instance of MC_MoveSuperimposed
            _instMoveSuperimposed : MC_MOVESUPERIMPOSED;
            /// Instance of MC_HaltSuperimposed
            _instHaltSuperimposed : MC_HALTSUPERIMPOSED;
            /// Instance of MC_GearIn
            _instGearIn : MC_GEARIN;
            /// Instance of MC_PhasingAbsolute
            _instPhasingAbsolute : MC_PHASINGABSOLUTE;
            /// Instance of MC_PhasingRelative
            _instPhasingRelative : MC_PHASINGRELATIVE;
            /// Instance of MC_OffsetAbsolute
            _instOffsetAbsolute : MC_OFFSETABSOLUTE;
            /// Instance of MC_OffsetRelative
            _instOffsetRelative : MC_OFFSETRELATIVE;
            /// Instance of MC_GearInPos
            _instGearInPos : MC_GEARINPOS;
            /// Instance of MC_GearInVelocity
            _instGearInVelocity : MC_GEARINVELOCITY;
            /// Instance of MC_GearOut
            _instGearOut : MC_GEAROUT;
            /// Instance of MC_CamIn
            _instCamIn : MC_CAMIN;
            /// Instance of MC_CamOut
            _instCamOut : MC_CAMOUT;
            /// Instance of MC_SynchronizedMotionSimulation
            _instSyncMotionSimulation : MC_SYNCHRONIZEDMOTIONSIMULATION;
        END_VAR

        VAR_TEMP
            // Temporary variable for enable FB
            tempEnable : BOOL;
            // Temporary variable for extended command
            tempNewExtendedCmd : DINT;
            // Temporary variable for enableAxis
            tempEnableAxis : BOOL;
            // Temporary variable for error in actual command
            tempErrorInCmd : BOOL;
            // Temporary DWord which indicates all rising edges of command word
            tempRisingCmd : DWORD;
            // TRUE: Stop or faststop selected in current cycle
            tempStopCmdSelected : BOOL;
            // Temporary variable for statusword of axis
            tempStatusWord : DWORD;
            // Temporary variable for open brake
            tempOpenBrake : BOOL;
            // Temporary DWord for evaluation of rising edges of basic command word
            tempDword : DWORD;
            // Temporary index
            tempIndex : INT;
            // Temporary counter for rising edges in command word
            tempCountRisEdges : USINT;
            // Temporary variable for basic motion command
            tempNewBasicMotionCmd : DINT;
            // TRUE: State change is active, stay in loop for one more cycle
            tempStateChangeActive : BOOL;
            // Temporary variable for superimposed motion command
            tempNewSupImpCmd : DINT;
            // Temporary DInt variable
            tempDInt : DINT;
            // Temporary LReal variable
            tempLReal : LREAL;
            // Temporary Bool variable
            tempBool : BOOL;
            // Temporary variable for homing command
            tempHoming : BOOL;
        END_VAR

        VAR CONSTANT
            // Axis type: External encoder
            EXTERNAL_ENCODER : INT := 1;
            // Axis type: Speed axis
            SPEED_AXIS : INT := 2;
            // Axis type: Positioning axis
            POS_AXIS : INT := 3;
            // Axis type: Synchronous axis
            SYNC_AXIS : INT := 4;
            // Length of status text
            STATUS_TEXT_LENGTH : INT := 39;
            // State of FB: MotionState, new commands are evaluated
            AXIS_MOTION : SINT := SINT#1;
            // State of FB: Error, falling edge at FB_ENABLE required
            FB_ERROR : SINT := SINT#5;
            // No command is selected
            CMD_NO_SELECTION : DWORD := DWORD#16#0000_0000;
            // State of basicMotion/superimposedMotion: No execution of a command
            NO_SELECTION : INT := 0;

            // State of FB: StoppingState, MC_HALT is executed, new commands are not evaluated
            AXIS_FAST_STOPPING : SINT := SINT#2;
            // State of FB: ErrorState: Selection if StopOnError must be executed (depending on config)
            AXIS_STOP_ON_ERROR_SELECTION : SINT := SINT#3;
            // State of FB: ErrorState: Execution of StopOnError
            AXIS_STOP_ON_ERROR_EXECUTION : SINT := SINT#4;

            // Jogmode continuous selected (MC_MOVEJOG)
            JOG_MODE_CONTINUOUS : INT := 0;

            // State of basicMotion: Execution of fast stop command
            FAST_STOP_SELECTED : INT := 1;
            // State of basicMotion: Execution of stop command
            STOP_SELECTED : INT := 2;
            // State of basicMotion: Execution of jog forward command
            JOG_FORWARD_SELECTED : INT := 4;
            // State of basicMotion: Execution of jog backward command
            JOG_BACKWARD_SELECTED : INT := 8;
            // State of basicMotion: Execution of jog command if forward and backward are selected
            JOG_FW_AND_BW_SELECTED : INT := 12;
            // State of basicMotion: Execution of move velocity command
            MOVE_VELOCITY_SELECTED : INT := 16;
            // State of basicMotion: Execution of active homing command
            ACTIVE_HOMING_SELECTED : INT := 1024;
            // State of basicMotion: Execution of position command (relative)
            POS_RELATIVE_SELECTED : INT := 32;
            // State of basicMotion: Execution of position command (absolute)
            POS_ABSOLUTE_SELECTED : INT := 64;
            // State of basicMotion: Execution of gearIn command
            GEAR_IN_RELATIVE_SELECTED : INT := 128;
            // State of basicMotion: Execution of gearInPos command
            GEAR_IN_ABSOLUTE_SELECTED : INT := 256;
            // State of basicMotion: Execution of gearInVelocity command
            GEAR_IN_VELOCITY_SELECTED : INT := 4096;
            // State of basicMotion: Execution of camIn command
            CAM_IN_SELECTED : INT := 512;
            // State of basicMotion: Execution of gear and camOut command
            GEAR_OUT_CAM_OUT_SELECTED : INT := 2048;
            // State of superimposedMotion: Execution of posSuperimposed command
            POS_SUPERIMPOSED_SELECTED : INT := 1;
            // State of superimposedMotion: Execution of haltSuperimposed command
            HALT_SUPERIMPOSED_SELECTED : INT := 8;
            // State of superimposedMotion: Execution of phasing command
            PHASING_SELECTED : INT := 2;
            // State of superimposedMotion: Execution of offset command
            OFFSET_SELECTED : INT := 4;

            // State of basicMotion command: No execution
            CMD_IDLE : INT := 0;
            // State of basicMotion command: Subsequent call
            CMD_BUSY : INT := 1;
            // State of basicMotion command: Finished with "DONE"
            CMD_DONE : INT := 2;
            // State of basicMotion command: Finished with "ABORTED"
            CMD_ABORTED : INT := 4;
            // State of basicMotion command: Finished with "ERROR"
            CMD_ERROR : INT := 8;
            // State of basicMotion command: Finished with other reason
            CMD_END_PROCESS : INT := 16;

            // State of torquelimiting command: Not enabled
            NO_TORQUE_LIMITING_ACTIVE : SINT := SINT#0;
            // State of torquelimiting command: Torquelimiting is active
            TORQUE_LIMITING_SELECTED : SINT := SINT#1;
            // State of torquelimiting command: Torquelimiting is disabling
            TORQUE_LIMITING_DISABLE : SINT := SINT#10;

            // First bitposition for detecting rising edges at basic motion command word
            BITPOSITION_BASIC_MOTION_CMD : SINT := SINT#4;
            // Last bitposition for detecting rising edges at command word
            BIT_POS_LAST : SINT := SINT#15;
            // The sign of the velocity specified at the "Velocity" parameter defines the direction of rotation.
            SPECIFIED_DIR : INT := 0;
            // Bit 12 in STW
            MASK_STW_BIT12 : WORD := WORD#16#1000;

            // State of homing command: No homing active
            NO_HOMING_ACTIVE : SINT := SINT#-10;
            // State of homing command: (Standard) homing with MC_HOME
            STANDARD_HOMING : SINT := SINT#-1;

            // First bitposition for detecting rising edges at superimposed motion command word
            BITPOSITION_SUPERIMPOSED_MOTION_CMD : SINT := SINT#0;

            // State of torquelimiting command: Homing on fixed stop is active
            FIXED_STOP_DETECTION_ACTIVE : SINT := SINT#2;
            // State of torquelimiting command: Homing on fixed stop is finished
            FIXED_STOP_DETECTION_FINISHED : SINT := SINT#3;
            // State of torquelimiting command: Error occurred at homing on fixed stop process, axis is in clamping
            FIXED_STOP_DETECTION_ERROR_IN_CLAMPING : SINT := SINT#5;
            // State of torquelimiting command: Error occurred at homing on fixed stop process, axis is not in clamping
            FIXED_STOP_DETECTION_ERROR_NOT_IN_CLAMPING : SINT := SINT#6;

            // State of homing command: Applicative homing on fixed stop process active
            HOMING_ON_FIXED_STOP : SINT := SINT#0;
            // State of homing command: Applicative homing on fixed stop with moving out of clamping process active
            HOMING_ON_FIXED_STOP_WITH_MOVING_OUT_OF_CLAMPING : SINT := SINT#1;
            // State of homing command: Applicative homing on fixed stop with moving to target position process active
            HOMING_ON_FIXED_STOP_WITH_MOVING_TO_TARGET_POSITION : SINT := SINT#2;

            // Scaling factor for moving out of clamping. 1.0 = positioning window
            DISTANCE_SCALING : LREAL := 1.05;
            // Fixed stop detection (Mode for MC_TORQUELIMITING)
            MODE_FIXED_STOP_DETECTION : INT := 1;
            // Positive/Forward direction of rotation
            FORWARD_DIR : INT := 1;
            // Negative/Backward direction of rotation
            BACKWARD_DIR : INT := 2;
            // Shortest path
            SHORTEST_WAY_DIR : INT := 3;
            // Direct homing (absolute). Parameter "position" at MC_HOME is effective
            DIRECT_HOMING : INT := 0;
            // Active homing. Parameter "position" at MC_HOME is effective
            ACTIVE_HOMING : INT := 3;
            // Active homing. The configured home position value in technology object is effective
            ACTIVE_HOMING_TO_DEF_VALUE : INT := 5;
            // Absolute encoder adjustment (absolute)
            ABSOLUTE_ENCODER_ADJUSTMENT : INT := 7;
            // Encodertype INCREMENTAL
            INCREMENTAL_ENCODER : INT := 0;

            // SubState of homing on fixed stop process: Idle
            HOMING_IDLE : SINT := SINT#0;
            // SubState of homing on fixed stop process: Detecting fixed stop
            HOMING_FIXED_STOP_DETECTION : SINT := SINT#1;
            // SubState of homing on fixed stop process: Homeprocess (MC_HOME)
            HOMING_PROCESS : SINT := SINT#2;
            // SubState of homing on fixed stop process: Positioning to homeposition
            HOMING_POSITION : SINT := SINT#3;

            // Substate of incremental jog process: Idle
            INC_JOG_IDLE : SINT := SINT#0;
            // Substate of incremental jog process: Start moving
            INC_JOG_START : SINT := SINT#1;
            // Substate of incremental jog process: Stop moving
            INC_JOG_STOP : SINT := SINT#3;

            // Jogmode incremental selected - start always with new increment when command is selected
            JOG_MODE_NEW_INCREMENT : INT := 1;
            // Jogmode incremental selected - continue with increment when command is selected again
            JOG_MODE_CONTINUE_INCREMENT : INT := 2;
            // Application of the cam: Once/not cyclic (MC_CAMIN)
            APPLICATION_MODE_ONCE : INT := 0;
            // State of MainSelectionState: Regular execution of basic motion commands
            CALL_BASIC_MOTION : INT := 0;
            // State of MainSelectionState: Reset of waiting synchronous commands
            ABORT_WAITING_GEARINPOS_OR_CAMIN : INT := 1;

            // Mode for MC_GearOut / MC_CamOut instruction
            CANCEL_ONLY_WAITING_GEARING_CAMMING : DINT := 5;
            // No operation active or waiting
            WFS_FS_NO_OPERATION : DINT := 0;
            // Function state / Waiting function state: GearIn
            WFS_FS_GEARIN : DINT := 1;
            // Function state / Waiting function state: GearInPos
            WFS_FS_GEARINPOS : DINT := 2;
            // Function state / Waiting function state: CamIn
            WFS_FS_CAMIN : DINT := 3;
            // Function state / Waiting function state: Gearout
            WFS_FS_GEAROUT : DINT := 4;
            // Function state / Waiting function state: CamOut
            WFS_FS_CAMOUT : DINT := 5;

            // GearOutCamOut mode: Automatic
            SYNCOUT_MODE_AUTOMATIC : DINT := -1;
            // GearOutCamOut mode: GearOut
            SYNCOUT_MODE_GEAROUT : DINT := 0;
            // GearOutCamOut mode: CamOut
            SYNCOUT_MODE_CAMOUT : DINT := 1;
            // Sync out state
            SYNCOUT_STATE_CHECK_WAITING : INT := 1;
            // Sync out state
            SYNCOUT_STATE_GEAROUT_WAITING_BUSY : INT := 2;
            // Sync out state
            SYNCOUT_STATE_CAMOUT_WAITING_BUSY : INT := 3;
            // Sync out state
            SYNCOUT_STATE_CHECK_ACTIVE : INT := 4;
            // Sync out state
            SYNCOUT_STATE_GEAROUT_ACTIVE_BUSY : INT := 5;
            // Sync out state
            SYNCOUT_STATE_CAMOUT_ACTIVE_BUSY : INT := 6;
            // Sync out state
            SYNCOUT_STATE_DONE : INT := 7;
            // Sync out state
            SYNCOUT_STATE_ABORTED : INT := 8;
            // Sync out state
            SYNCOUT_STATE_ERROR : INT := 9;

            // State of motionSimulation: Axis is not in simulation
            AXIS_NOT_IN_SIM : SINT := SINT#0;
            // State of motionSimulation: Setting axis in simulation
            AXIS_STATE_SET_SIM : SINT := SINT#1;
            // State of motionSimulation: Disable axis
            AXIS_DISABLE : SINT := SINT#2;
            // State of motionSimulation: Axis is in simulation
            AXIS_STATE_IN_SIM : SINT := SINT#3;
            // State of motionSimulation: Enable axis
            AXIS_ENABLE : SINT := SINT#4;
            // State of motionSimulation: Resetting axis simulation
            AXIS_STATE_RESET_SIM : SINT := SINT#5;
        END_VAR

        //----------------------------------------------------------------------------------------------
        // Enable / disable FB
        //----------------------------------------------------------------------------------------------
        tempEnable := enable; // Create temporary process image
        IF NOT tempEnable AND _enableOld THEN

            // Reset outputs
            // ==========================================================
            // Error and valid outputs are reset with falling edge of enable input
            error := FALSE;
            valid := FALSE;
            status := AxisStatus#STATUS_NO_CALL;
            statusText := STRING#'STATUS_NO_CALL';
            subfunctionStatus := WORD#16#0000;
            _subfunctionStatus := WORD#16#0000;

            // Reset status outputs
            axisEnabled := FALSE;
            resetActive := FALSE;

            // Reset outputs for homing commands
            homingCommandBusy := FALSE;
            homingCommandDone := FALSE;
            homingCommandAborted := FALSE;
            homingSelected := FALSE;
            // Reset outputs for torquelimiting command
            torqueLimitingSelected := FALSE;
            inLimitation := FALSE;

            // Reset outputs for basic motion commands
            commandDone := FALSE;
            commandBusy := FALSE;
            commandAborted := FALSE;
            inVelocity := FALSE;
            fastStopSelected := FALSE;
            stopSelected := FALSE;
            jogSelected := FALSE;
            moveVelocitySelected := FALSE;
            // Outputs for for up to LAxisCtrl_PosAxis
            posRelativeSelected := FALSE;
            posAbsoluteSelected := FALSE;
            inClamping := FALSE;

            // Reset outputs for superimposed motion commands
            superimposedBusy := FALSE;
            superimposedDone := FALSE;
            superimposedAborted := FALSE;
            superimposedStart := FALSE;
            posSuperimposedSelected := FALSE;
            haltSuperimposedSelected := FALSE;
            startSync := FALSE;
            inSync := FALSE;
            endOfProfile := FALSE;
            gearInRelativeSelected := FALSE;
            inSimulation := FALSE;
            gearInAbsoluteSelected := FALSE;
            gearInVelocitySelected := FALSE;
            phasingSelected := FALSE;
            offsetSelected := FALSE;
            camInSelected := FALSE;
            gearOutCamOutSelected := FALSE;

            // Reset internal variables
            // ==========================================================
            _errorUserCleared := FALSE;
            _errorAutoCleared := FALSE;
            _status := AxisStatus#STATUS_NO_CALL;
            _statusOld := AxisStatus#STATUS_NO_CALL;
            _diagnostics := _emptyDiagnostics;

            _state := AXIS_MOTION;
            _firstCycleReset := FALSE;
            _powerErrorOld := FALSE;
            _resetState := CMD_IDLE;
            _firstCycleResetError := FALSE;

            _extendedCommand := CMD_NO_SELECTION;
            _extendedCommandOld := CMD_NO_SELECTION;
            _enableAxisOld := FALSE;
            _homingOld := FALSE;
            _firstCycleHoming := FALSE;
            _passiveHomingState := NO_HOMING_ACTIVE;
            _exeOfHoming := CMD_BUSY;
            _basicCommand := CMD_NO_SELECTION;
            _basicCommandOld := CMD_NO_SELECTION;
            _basicMotionState := NO_SELECTION;
            _exeOfBasicMotion := CMD_BUSY;
            _firstCycleBasicMotion := FALSE;
            _applicativeBasicMotionError := FALSE;
            _velocityChangeOnTheFly := FALSE;
            _basicVelocity := 0.0;
            _basicAcceleration := 0.0;
            _basicDeceleration := 0.0;
            _basicJerk := 0.0;

            _firstCycleDone := FALSE;

            _torqueLimitingState := NO_TORQUE_LIMITING_ACTIVE;
            _torqueLimitingErrorOld := FALSE;
            _jogMode := JOG_MODE_CONTINUOUS;
            _direction := SPECIFIED_DIR;

            _homingPosition := 0.0;
            _homingSubState := HOMING_IDLE;
            _incJogSubState := INC_JOG_IDLE;
            _incJogStartPosition := 0.0;
            _incJogDirectionOld := 0;
            _increment := 0.0;
            _incJogDistance := 0.0;
            _resetIncJog := TRUE;
            _position := 0.0;
            _positionChangeOnTheFly := FALSE;

            _activeHomingState := NO_HOMING_ACTIVE;
            _supImpCommand := CMD_NO_SELECTION;
            _supImpCommandOld := CMD_NO_SELECTION;
            _supImpMotionState := NO_SELECTION;
            _exeOfSupImpMotionState := CMD_BUSY;
            _firstCycleSupImpMotion := FALSE;
            _supImpMotionPosition := 0.0;
            _applicativeSupImpMotionError := FALSE;
            _ratioChangeOnTheFly := FALSE;
            _ratioNumerator := 0;
            _ratioDenominator := 0;
            // Tags for synchronized motion simulation
            _changePhaseShiftOnTheFly := FALSE;
            _changeOffsetOnTheFly := FALSE;
            _phaseShift := 0.0;
            _offsetValue := 0.0;
            _phaseAbsolute := TRUE;
            _offsetAbsolute := TRUE;
            _enableAxis := FALSE;
            _syncMotionSimulationState := AXIS_NOT_IN_SIM;
            _synchronizedMotionErrorOld := FALSE;
            _mainSelectionState := 0;
            _applicationMode := 0;

            _waitingFunctionState := 0;
            _waitingFunctionStateAbortAutomatic := -1;
            _functionState := 0;
            // ===========================================================

            // Disable Axis
            IF (_instPower.Busy = TRUE) THEN
                _instPower(Axis := _refAxis^,
                           Enable := FALSE,
                           StartMode := config.power.startMode,
                           StopMode := config.power.stopMode);
                // Check if error occurred
                IF (_instPower.Error = TRUE) THEN
                    // Write only diagnostics if error occurred at falling edge of MC_POWER
                    diagnostics.status := AxisStatus#ERR_MC_POWER;
                    diagnostics.subfunctionStatus := _instPower.ErrorId;
                    diagnostics.basicMotionState := _basicMotionState;
                    diagnostics.superimposedMotionState := _supImpMotionState;
                END_IF;
            END_IF;

            // Reset old values for master and cam
            _masterOld := UINT#0;
            _camOld := UINT#0;

            // Set axis references to null when block is being disabled
            _refAxis := NULL;
            _refSpeedAxis := NULL;
            _refPosAxis := NULL;
            _refSyncAxis := NULL;
            _refExtEncoder := NULL;
            _refMasterAxis := NULL;
            _refCamBase := NULL;

            // Set old value of enable for edge detection and end execution
            _enableOld := tempEnable;
            RETURN;

        // Check if FB is enabled - first cycle
        ELSIF tempEnable AND NOT _enableOld THEN

            // Busy is set at rising edge of enable input
            busy := TRUE;
            status := AxisStatus#STATUS_FB_FIRST_CALL;
            statusText := STRING#'STATUS_FB_FIRST_CALL';
            // StatStatus will be written in next cycle
            _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
            _statusText := STRING#'STATUS_SUBSEQUENT_CALL';

            // Reset error and diagnostics outputs
            _errorUserCleared := FALSE;
            _errorAutoCleared := FALSE;
            diagnostics := _emptyDiagnostics;
            _diagnostics := _emptyDiagnostics;

            // Copy inputs
            _extendedCommand.%X0 := resetAxis;
            _basicCommand.%X8 := gearInAbsolute;
            _basicCommand.%X12 := gearInVelocity;
            _basicCommand.%X9 := camIn;
            _basicCommand.%X11 := gearOutCamOut;
            _supImpCommand.%X1 := phasing;
            _supImpCommand.%X2 := offset;
            _basicCommand.%X7 := gearInRelative;
            _basicCommand.%X5 := posRelative;
            _basicCommand.%X6 := posAbsolute;
            _supImpCommand.%X0 := posSuperimposed;
            _supImpCommand.%X3 := haltSuperimposed;
            _supImpCommandOld := _supImpCommand;

            _basicCommand.%X0 := fastStop;
            _basicCommand.%X1 := stop;
            _basicCommand.%X2 := jogForward;
            _basicCommand.%X3 := jogBackward;
            _basicCommand.%X4 := moveVelocity;
            _basicCommandOld := _basicCommand;
            // Set old value of homing input
            _homingOld := homing;

            _extendedCommandOld := _extendedCommand;
            // Set old value of enable for edge detection and end execution
            _enableOld := tempEnable;

            // resolve reference for axis input as TO_Axis (basic type for all axes)
            _refAxis := AsAxisRef(axis);
            IF _refAxis = NULL THEN
                // Invalid axis
                error := TRUE;
                _errorUserCleared := TRUE;
                status := AxisStatus#ERR_INVALID_AXIS;
                statusText := STRING#'ERR_INVALID_AXIS';
                diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
            END_IF;

            CASE GetType(axis) OF
                TO_Type#SynchronousAxis:
                    _typeAxis := SYNC_AXIS;

                    // attempt to resolve all inherited technology objects (TO_SpeedAxis, TO_PositioningAxis, TO_SynchronousAxis)
                    _refSpeedAxis := AsSpeedAxisRef(axis);
                    _refPosAxis := AsPositioningAxisRef(axis);
                    _refSyncAxis := AsSynchronousAxisRef(axis);

                    // TODO: generate other error for this case?
                    IF _refSpeedAxis = NULL OR _refPosAxis = NULL OR _refSyncAxis = NULL THEN
                        // Invalid axis
                        error := TRUE;
                        _errorUserCleared := TRUE;
                        status := AxisStatus#ERR_INVALID_AXIS;
                        statusText := STRING#'ERR_INVALID_AXIS';
                        diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
                    END_IF;

                TO_Type#PositioningAxis:
                    _typeAxis := POS_AXIS;

                    // attempt to resolve all inherited technology objects (TO_SpeedAxis, TO_PositioningAxis)
                    _refSpeedAxis := AsSpeedAxisRef(axis);
                    _refPosAxis := AsPositioningAxisRef(axis);

                    // TODO: generate other error for this case?
                    IF _refSpeedAxis = NULL OR _refPosAxis = NULL THEN
                        // Invalid axis
                        error := TRUE;
                        _errorUserCleared := TRUE;
                        status := AxisStatus#ERR_INVALID_AXIS;
                        statusText := STRING#'ERR_INVALID_AXIS';
                        diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
                    END_IF;

                TO_Type#SpeedAxis:
                    _typeAxis := SPEED_AXIS;

                    _refSpeedAxis := AsSpeedAxisRef(axis);

                    // TODO: generate other error for this case?
                    IF _refSpeedAxis = NULL THEN
                        // Invalid axis
                        error := TRUE;
                        _errorUserCleared := TRUE;
                        status := AxisStatus#ERR_INVALID_AXIS;
                        statusText := STRING#'ERR_INVALID_AXIS';
                        diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
                    END_IF;

                TO_Type#ExternalEncoder:
                    _typeAxis := EXTERNAL_ENCODER;

                    _refExtEncoder := AsExternalEncoderRef(axis);

                    // TODO: generate other error for this case?
                    IF _refExtEncoder = NULL THEN
                        // Invalid axis
                        error := TRUE;
                        _errorUserCleared := TRUE;
                        status := AxisStatus#ERR_INVALID_AXIS;
                        statusText := STRING#'ERR_INVALID_AXIS';
                        diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
                    END_IF;

                ELSE
                    // Invalid axis
                    error := TRUE;
                    _errorUserCleared := TRUE;
                    status := AxisStatus#ERR_INVALID_AXIS;
                    statusText := STRING#'ERR_INVALID_AXIS';
                    diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
            END_CASE;
        RETURN;

        // Check if function block is disabled or UserClearedError is present
        ELSIF NOT tempEnable OR _errorUserCleared THEN

            IF (tempEnable = FALSE) THEN
                status := AxisStatus#STATUS_NO_CALL;
                statusText := STRING#'STATUS_NO_CALL';
            END_IF;

            // Disable Axis
            IF (_instPower.Busy = TRUE) THEN
                _instPower(Axis := _refAxis^,
                           Enable := FALSE,
                           StartMode := config.power.startMode,
                           StopMode := config.power.stopMode);
                // Check if error occurred
                IF (_instPower.Error = TRUE) THEN
                    diagnostics.status := AxisStatus#ERR_MC_POWER;
                    diagnostics.subfunctionStatus := _instPower.ErrorId;
                    diagnostics.basicMotionState := _basicMotionState;
                    diagnostics.superimposedMotionState := _supImpMotionState;
                END_IF;
            ELSE
                // Reset if torque limiting is busy and axis is disabled
                IF (_instTorqueLimiting.Busy = TRUE)
                    OR (_instSyncMotionSimulation.Busy = TRUE)
                THEN
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := FALSE);
                    // Disable synchronized motion simulation
                    _instSyncMotionSimulation(Slave := _refSyncAxis^,
                                              Enable := FALSE);
                ELSE
                    busy := FALSE;
                END_IF;
            END_IF;

            // Reset old values for master and cam
            _masterOld := UINT#0;
            _camOld := UINT#0;

            // Set axis references to null when block is being disabled
            _refAxis := NULL;
            _refSpeedAxis := NULL;
            _refPosAxis := NULL;
            _refSyncAxis := NULL;
            _refExtEncoder := NULL;
            _refMasterAxis := NULL;
            _refCamBase := NULL;

            _enableOld := tempEnable;
            RETURN;

        ELSE

            // Read status word of the axis cyclically (needed for MC_Power call)
            CASE _typeAxis OF // Axis type is determined (checked) when the FB is enabled
                SPEED_AXIS, POS_AXIS, SYNC_AXIS:
                    // Axis type is TO_SpeedAxis or TO_PositioningAxis or TO_SynchronousAxis
                    tempStatusWord := _refSpeedAxis^.StatusWord;

                EXTERNAL_ENCODER:
                    // Axis type is TO_ExternalEncoder
                    tempStatusWord := _refExtEncoder^.StatusWord;

                ELSE
                    // Invalid axis
                    tempStatusWord := DWORD#16#0000_0000;
            END_CASE;

            // Copy extended inputs
            _extendedCommand.%X0 := resetAxis;
            tempEnableAxis := enableAxis;
            _extendedCommand.%X1 := torqueLimiting;
            _basicCommand.%X0 := fastStop;
            _basicCommand.%X1 := stop;
            _basicCommand.%X2 := jogForward;
            _basicCommand.%X3 := jogBackward;
            _basicCommand.%X4 := moveVelocity;
            tempOpenBrake := openBrake;
            _basicCommand.%X5 := posRelative;
            _basicCommand.%X6 := posAbsolute;
            _supImpCommand.%X0 := posSuperimposed;
            _supImpCommand.%X3 := haltSuperimposed;
            tempHoming := homing;
            IF (tempHoming = TRUE) AND (_homingOld = FALSE) THEN
                // Rising edge on homing input
                _extendedCommand.%X2 := TRUE;
                IF FALSE
                    OR (config.homing.extendedMode = HOMING_ON_FIXED_STOP) // Extended Homing mode (active)
                    OR (config.homing.extendedMode = HOMING_ON_FIXED_STOP_WITH_MOVING_OUT_OF_CLAMPING)  // Extended Homing mode (active)
                    OR (config.homing.extendedMode = HOMING_ON_FIXED_STOP_WITH_MOVING_TO_TARGET_POSITION)
                    OR (config.homing.extendedMode = -1) AND ((config.homing.mode = ACTIVE_HOMING) OR (config.homing.mode = ACTIVE_HOMING_TO_DEF_VALUE)) // Extended Homing mode (active)
                THEN
                    // Active Homing selected
                    _basicCommand.%X10 := TRUE; // Cmd is BasicMotionCmd
                    _extendedCommand.%X2 := FALSE;
                    // ELSE
                    //   ; // Passive Homing selected
                    //   // Bit in extended cmd already written
                END_IF;

            ELSIF (tempHoming = FALSE) AND (_homingOld = TRUE) THEN
                // Falling edge on homing input
                _extendedCommand.%X2 := FALSE;
                _basicCommand.%X10 := FALSE;
                // ELSE
                //   ; // Do nothing - wait for rising / Falling edge
            END_IF;
            _basicCommand.%X7 := gearInRelative;
            _basicCommand.%X8 := gearInAbsolute;
            _basicCommand.%X12 := gearInVelocity;
            _basicCommand.%X9 := camIn;
            _basicCommand.%X11 := gearOutCamOut;
            _supImpCommand.%X1 := phasing;
            _supImpCommand.%X2 := offset;

            // Statemachine for synchronized motion simulation

            REPEAT
                tempStateChangeActive := FALSE;
                CASE _syncMotionSimulationState OF
                    AXIS_NOT_IN_SIM:
                        // Axis NOT in simulation
                        IF (config.power.syncMotionSimulation = TRUE) THEN
                            // SynchronizedMotionSimulation is set
                            IF (tempEnableAxis = FALSE) AND (_enableAxisOld = TRUE) THEN
                                // Falling edge at enableAxis --> set simulation
                                CASE config.power.syncMotionSimulationExtendedMode OF
                                    -1: // Automatic when axis is in synchronous operation
                                        IF tempStatusWord.%X22 THEN // Check if axis is in synchronous operation
                                            _syncMotionSimulationState := AXIS_STATE_SET_SIM;
                                            _enableAxis := TRUE;
                                            tempStateChangeActive := TRUE;
                                        ELSE
                                            _enableAxis := tempEnableAxis;
                                        END_IF;

                                    0: // Start always simulation
                                        _syncMotionSimulationState := AXIS_STATE_SET_SIM;
                                        _enableAxis := TRUE;
                                        tempStateChangeActive := TRUE;
                                ELSE
                                    _enableAxis := tempEnableAxis; // : disable axis anyway
                                    // Error - Invalid extended mode
                                    _status := AxisStatus#ERR_INVALID_SYNCHRONIZED_EXTENDED_MODE;
                                    _statusText := STRING#'ERR_INVALID_SYNCHRONIZED_EXTENDED_MODE';
                                    _errorAutoCleared := TRUE;
                                    _diagnostics.basicMotionState := _basicMotionState;
                                    _diagnostics.superimposedMotionState := _supImpMotionState;
                                    _diagnostics.subfunctionStatus := WORD#0000;
                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                END_CASE;
                            ELSE
                                // FALSE or rising edge at input enableAxis
                                _enableAxis := tempEnableAxis;
                            END_IF;
                        ELSE
                            // SynchronizedMotionSimulation not set
                            // MC_POWER is only controlled by enableAxis input
                            _enableAxis := tempEnableAxis;
                        END_IF;

                    AXIS_STATE_SET_SIM:
                        // Set the axis in simulation
                        //----------------------------------------------------------
                        // Enable SynchronizedMotionSimulation
                        _instSyncMotionSimulation(Slave := _refSyncAxis^,
                                                  Enable := TRUE);
                        //----------------------------------------------------------
                        IF (_instSyncMotionSimulation.InSimulation = TRUE) THEN
                            _enableAxis := FALSE;
                            // Axis in Simulation - Change state
                            _syncMotionSimulationState := AXIS_DISABLE;
                        ELSIF (_instSyncMotionSimulation.Error = TRUE) THEN
                            // Error occurred - Disable Axis immediately
                            _enableAxis := FALSE;
                            _syncMotionSimulationState := AXIS_STATE_RESET_SIM;
                        // ELSE
                            //   ; // Wait for Axis is in simulation
                        END_IF;

                    AXIS_DISABLE:
                        // Disable axis
                        //----------------------------------------------------------
                        // Enable SynchronizedMotionSimulation
                        _instSyncMotionSimulation(Slave := _refSyncAxis^,
                                                  Enable := TRUE);
                        //----------------------------------------------------------
                        IF (_instPower.Error = TRUE) THEN
                            _syncMotionSimulationState := AXIS_STATE_RESET_SIM;
                        ELSIF (_instPower.Status = FALSE) THEN
                            // Axis disabled
                            _syncMotionSimulationState := AXIS_STATE_IN_SIM;
                        // ELSE
                            //   ; // Wait for Axis is disabled
                        END_IF;

                    AXIS_STATE_IN_SIM:
                        // Axis is in simulation
                        //----------------------------------------------------------
                        // Enable SynchronizedMotionSimulation
                        _instSyncMotionSimulation(Slave := _refSyncAxis^,
                                                  Enable := TRUE);
                        //----------------------------------------------------------
                        IF (tempEnableAxis = TRUE) AND (_enableAxisOld = FALSE) THEN
                            // Rising edge at enableAxis --> reset simulation
                            _syncMotionSimulationState := AXIS_ENABLE;
                            _enableAxis := TRUE;
                            tempStateChangeActive := TRUE;
                        ELSIF (config.power.syncMotionSimulation = FALSE) THEN
                            // End of synchronizedMotionSimulation by config without starting Axis
                            _syncMotionSimulationState := AXIS_STATE_RESET_SIM;
                            tempStateChangeActive := TRUE;
                        // ELSE
                            //   ; // Wait for rising edge at enableAxis
                        END_IF;

                    AXIS_ENABLE:
                        // Enable Axis
                        //----------------------------------------------------------
                        // Enable SynchronizedMotionSimulation while axis is enabling
                        _instSyncMotionSimulation(Slave := _refSyncAxis^,
                                                  Enable := TRUE);
                        //----------------------------------------------------------

                        IF (tempEnableAxis = FALSE) AND (_enableAxisOld = TRUE) THEN
                            _syncMotionSimulationState := AXIS_STATE_RESET_SIM;
                            _enableAxis := FALSE;
                        ELSIF (tempStatusWord.%X0 = TRUE) OR (_instPower.Error = TRUE)
                        // Reset simulation if axis is enabled or MC_POWER.STATUS = FALSE (Axis Error)
                        THEN
                            // FALSE on enable input
                            _syncMotionSimulationState := AXIS_STATE_RESET_SIM;
                            tempStateChangeActive := TRUE;
                        // ELSE
                            //   ; // Wait for Axis is Enabled
                        END_IF;

                    AXIS_STATE_RESET_SIM:
                        // Reset the axis simulation
                        //----------------------------------------------------------
                        // Enable SynchronizedMotionSimulation
                        _instSyncMotionSimulation(Slave := _refSyncAxis^,
                                                Enable := FALSE);
                        //----------------------------------------------------------
                        IF (_instSyncMotionSimulation.InSimulation = FALSE) AND (_instSyncMotionSimulation.Busy = FALSE) THEN
                            // Axis simulation is disabled
                            _syncMotionSimulationState := AXIS_NOT_IN_SIM;
                        // ELSE
                            //   ; // Wait for axis simulation is disabled
                        END_IF;

                        IF (tempEnableAxis = FALSE) AND (_enableAxisOld = TRUE) THEN
                            _enableAxis := FALSE;
                        END_IF;
                ELSE
                    // Errorhandling
                    _status := AxisStatus#ERR_UNDEFINED_MOTION_SIMULATION_STATE;
                    _statusText := STRING#'ERR_UNDEFINED_MOTION_SIMULATION_STATE';
                    _errorUserCleared := TRUE;
                    _diagnostics.subfunctionStatus := WORD#0000;
                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                    _diagnostics.basicMotionState := _basicMotionState;
                    _diagnostics.superimposedMotionState := _supImpMotionState;
                    // Set error state
                    _state := FB_ERROR;
                END_CASE;
            UNTIL (tempStateChangeActive = FALSE)
            END_REPEAT;

            // Evaluation of MC_Command
            IF (_instSyncMotionSimulation.Error = TRUE) AND (_synchronizedMotionErrorOld = FALSE) THEN
                // Errorhandling - Set error only at rising edge
                _errorAutoCleared := TRUE;
                _status := AxisStatus#ERR_MC_SYNCHRONIZEDMOTIONSIMULATION;
                _statusText := STRING#'ERR_MC_SYNCHRONIZEDMOTIONSIMULATION';
                _diagnostics.basicMotionState := _basicMotionState;
                _diagnostics.superimposedMotionState := _supImpMotionState;
                _diagnostics.subfunctionStatus := _instSyncMotionSimulation.ErrorId;
                _subfunctionStatus := _instSyncMotionSimulation.ErrorId;
            ELSIF (_instSyncMotionSimulation.Error = FALSE) AND (_status = AxisStatus#ERR_MC_SYNCHRONIZEDMOTIONSIMULATION)
            THEN
                // Reset error if error gone at respective Status
                _errorAutoCleared := FALSE;
                _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
                _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
            END_IF;
            _synchronizedMotionErrorOld := _instSyncMotionSimulation.Error;
            tempEnableAxis := _enableAxis;

            // Enable and disable axis
            IF (config.power.externalMC_PowerCall = FALSE) THEN
                // Call MC_POWER
                // Do not call the MC_Power instance if the axis is successfully enabled -> Reduce the runtime of the LAxisCtrl block
                // Only call the instance if at least one of the following conditions is fulfilled
                IF ((tempEnableAxis = TRUE) AND ((_instPower.Busy = FALSE) OR (_instPower.Status = FALSE))) // "enable axis" is given and enabling via MC_Power is in progress
                    OR (tempStatusWord.%X0 = FALSE) // Axis is disabled
                    OR (tempEnableAxis = FALSE) // "Remove axis enable" is set
                    OR (_instPower.Error = TRUE) // An error occurred in Motion Control instruction "MC_Power"
                THEN // Call the MC_Power instance
                    _instPower(Axis := _refAxis^,
                               Enable := tempEnableAxis,
                               StartMode := config.power.startMode,
                               StopMode := config.power.stopMode);
                END_IF;

                // Set and Reset of Error
                IF (_instPower.Error = TRUE) AND
                    ((_status = AxisStatus#STATUS_SUBSEQUENT_CALL) OR (_powerErrorOld = FALSE))
                THEN
                    // Error is set at rising edge of MC_POWER.Error
                    // Errorhandling
                    _status := AxisStatus#ERR_MC_POWER;
                    _statusText := STRING#'ERR_MC_POWER';
                    _errorAutoCleared := TRUE;
                    _diagnostics.basicMotionState := _basicMotionState;
                    _diagnostics.superimposedMotionState := _supImpMotionState;
                    _diagnostics.subfunctionStatus := _instPower.ErrorId;
                    _subfunctionStatus := _instPower.ErrorId;

                ELSIF (_status = AxisStatus#ERR_MC_POWER) AND (_instPower.Error = FALSE)
                THEN
                    // Reset Error
                    _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
                    _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
                    _errorAutoCleared := FALSE;

                ELSIF (tempEnableAxis = TRUE) AND (_enableAxisOld = FALSE) THEN
                    // Reset Error
                    _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
                    _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
                    _errorAutoCleared := FALSE;
                    _diagnostics := _emptyDiagnostics;
                // ELSE
                    //   ; // Do nothing
                END_IF;
            END_IF;

            IF tempOpenBrake AND NOT _openBrakeOld THEN
                // Open
                _instSetAxisSTW(Axis := _refSpeedAxis^,
                                Execute := FALSE,
                                STW1 := MASK_STW_BIT12,
                                STW1BitMask := MASK_STW_BIT12);
                _brakeChangeActive := TRUE;
                _brakeOpened := TRUE;

            ELSIF NOT tempOpenBrake AND _openBrakeOld THEN
                // Close
                _instSetAxisSTW(Axis := _refSpeedAxis^,
                                Execute := FALSE,
                                STW1 := WORD#16#0000,
                                STW1BitMask := MASK_STW_BIT12);
                _brakeChangeActive := TRUE;
                _brakeOpened := FALSE;
            END_IF;

            IF _brakeChangeActive THEN
                // Call of MC command
                _instSetAxisSTW(Axis := _refSpeedAxis^,
                                Execute := TRUE);

                IF NOT _instSetAxisSTW.Busy THEN
                    _brakeChangeActive := FALSE;
                END_IF;
            END_IF;

            // Edge detection
            _openBrakeOld := tempOpenBrake;
        END_IF;

        //----------------------------------------------------------------------------------------------
        // Resolve TO reference of master and cam
        //----------------------------------------------------------------------------------------------
        // resolve reference for master input as TO_Axis (every synchronous operation needs at least a type of TO_Axis for its master input)
        IF master <> UINT#0 AND master <> _masterOld THEN
            _refMasterAxis := AsAxisRef(master);

            // TODO: generate other error for this case?
            IF _refMasterAxis = NULL THEN
                // Invalid axis
                error := TRUE;
                _errorUserCleared := TRUE;
                status := AxisStatus#ERR_INVALID_AXIS;
                statusText := STRING#'ERR_INVALID_AXIS';
                diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
            END_IF;
        END_IF;

        _masterOld := master;

        // resolve reference for cam input as TO_CamBase (every cam operation needs at least a type of TO_CamBase for its cam input)
        IF cam <> UINT#0 AND cam <> _camOld THEN
            _refCamBase := AsCamBaseRef(cam);

            // TODO: generate other error for this case?
            IF _refCamBase = NULL THEN
                // Invalid axis
                error := TRUE;
                _errorUserCleared := TRUE;
                status := AxisStatus#ERR_INVALID_AXIS;
                statusText := STRING#'ERR_INVALID_AXIS';
                diagnostics.status := AxisStatus#ERR_INVALID_AXIS;
            END_IF;
        END_IF;

        _camOld := cam;

        //----------------------------------------------------------------------------------------------
        // FB Statemachine
        //----------------------------------------------------------------------------------------------
        CASE _state OF
            AXIS_MOTION:
                // Check command inputs
                IF (_extendedCommand = CMD_NO_SELECTION)
                    AND (_basicCommand = CMD_NO_SELECTION)
                    AND (_supImpCommand = CMD_NO_SELECTION)
                THEN
                    // Command is reset
                    IF (_instPower.Error = TRUE) THEN
                        // Errorhandling
                        _status := AxisStatus#ERR_MC_POWER;
                        _statusText := STRING#'ERR_MC_POWER';
                        _errorAutoCleared := TRUE;
                    ELSIF (_instSyncMotionSimulation.Error = TRUE) THEN
                        ; // Do nothing

                    ELSIF (_instTorqueLimiting.Error = TRUE) THEN
                        ; // Do not reset if torque limiting error is pending

                    ELSE
                        // Reset Error only if no Error at MC_POWER is present
                        _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
                        _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
                        _errorAutoCleared := FALSE;
                    END_IF;

                ELSIF (_extendedCommand = _extendedCommandOld)
                    AND (_basicCommand = _basicCommandOld)
                    AND (_supImpCommand = _supImpCommandOld)
                THEN
                    ; // No change at command - do nothing

                ELSE
                    // Command changed
                    tempNewExtendedCmd := NO_SELECTION;
                    tempNewBasicMotionCmd := NO_SELECTION;
                    tempNewSupImpCmd := NO_SELECTION;
                    tempErrorInCmd := FALSE;

                    // Check basic motion command
                    IF (_basicCommand = _basicCommandOld) THEN
                        ; // Do nothing
                    ELSE
                        // Evaluate rising edges for basic motion command word - all rising edges of basic command word saved in tempRisingBasicCmd
                        tempRisingCmd := ((_basicCommand XOR _basicCommandOld) AND _basicCommand);
                        tempCountRisEdges := USINT#0; // Initialize counter for rising edges
                        // Count rising edges in tempRisingBasicCmd
                        FOR tempIndex := BITPOSITION_BASIC_MOTION_CMD TO BIT_POS_LAST DO
                            tempDword := SHR(tempRisingCmd, TO_USINT(tempIndex));
                            // Check for rising edge
                            IF (tempDword.%X0 = TRUE) THEN
                                tempCountRisEdges := tempCountRisEdges + USINT#1; // Increment at rising edge
                            END_IF;
                        END_FOR;
                        IF (tempRisingCmd.%X2 = TRUE) OR (tempRisingCmd.%X3 = TRUE) THEN
                            tempCountRisEdges := tempCountRisEdges + USINT#1; // jogForward AND/OR jogBackward is standing for 1 Command/rising edge
                        END_IF;

                        // Check Basic motion command
                        IF (tempCountRisEdges = 1)
                            OR (tempRisingCmd.%X0 = TRUE) // fastStop selected
                            OR (tempRisingCmd.%X1 = TRUE) // Stop selected
                        THEN
                            // Valid basic motion command selected
                            IF (tempRisingCmd.%X0 = TRUE) THEN
                                // FastStop selected
                                _state := AXIS_FAST_STOPPING;
                                tempNewBasicMotionCmd := FAST_STOP_SELECTED;
                                tempStopCmdSelected := TRUE;
                            ELSIF (tempRisingCmd.%X1 = TRUE) THEN
                                // Stop selected
                                tempNewBasicMotionCmd := STOP_SELECTED;
                                tempStopCmdSelected := TRUE;
                            ELSE
                                // Valid basic command priority 3 selected
                                // Set basic motion state
                                tempNewBasicMotionCmd := TO_DINT(tempRisingCmd);
                            END_IF;

                        ELSIF (tempCountRisEdges > 1) THEN
                            // Errorhandling - Invalid command
                            _status := AxisStatus#ERR_INVALID_BASIC_MOTION_CMD;
                            _statusText := STRING#'ERR_INVALID_BASIC_MOTION_CMD';
                            tempErrorInCmd := TRUE;
                        // ELSE
                            //   ; // Falling edge detection
                        END_IF;
                    END_IF;


                    // Check superimposed motion command
                    IF (_supImpCommand = _supImpCommandOld) THEN
                        ; // Do nothing
                    ELSE
                        // Superimposed motion command selected
                        IF (tempErrorInCmd = FALSE) AND // No Stop command selected in current cycle
                            (tempStopCmdSelected = FALSE)
                        THEN
                            tempRisingCmd := ((_supImpCommand XOR _supImpCommandOld) AND _supImpCommand);
                            tempCountRisEdges := USINT#0; // Initialize counter for rising edges
                            // Count rising edges in tempRisingSupImpCmd
                            FOR tempIndex := BITPOSITION_SUPERIMPOSED_MOTION_CMD TO BIT_POS_LAST DO
                                tempDword := SHR(tempRisingCmd, TO_USINT(tempIndex));
                                // Check for rising edge
                                IF (tempDword.%X0 = TRUE) THEN
                                    tempCountRisEdges := tempCountRisEdges + USINT#1;
                                END_IF;
                            END_FOR;

                            IF (tempCountRisEdges = 1) THEN
                                // Valid superimposed motion command
                                tempNewSupImpCmd := TO_DINT(tempRisingCmd);

                            ELSIF (tempCountRisEdges > 1) THEN
                                // Invalid Superimposed motion command
                                _status := AxisStatus#ERR_INVALID_SUPERIMPOSED_MOTION_CMD;
                                _statusText := STRING#'ERR_INVALID_SUPERIMPOSED_MOTION_CMD';
                                tempErrorInCmd := TRUE;
                            // ELSE
                                //   ; // Falling edge detection
                            END_IF;
                        // ELSE
                            //   ; // Stop or Faststop command selected OR error in BasicCommand
                        END_IF;
                    END_IF;


                    // Check extended command (reset, homing, torquelimiting)
                    IF (_extendedCommand = _extendedCommandOld) THEN
                        ; // Do nothing
                    ELSE
                        // Extended command selected
                        IF (tempErrorInCmd = FALSE) THEN
                            tempRisingCmd := ((_extendedCommand XOR _extendedCommandOld) AND _extendedCommand);
                            // Rising edge on torquelimiting command
                            IF (tempRisingCmd.%X1 = TRUE) THEN
                                tempNewExtendedCmd.%X1 := TRUE;
                                // Rising Edge at Homing on Fixed Stop and Torquelimiting
                                IF (tempNewBasicMotionCmd.%X10 = TRUE) AND (config.homing.extendedMode = 0) THEN
                                    // Errorhandling
                                    _status := AxisStatus#ERR_INVALID_EXTENDED_CMD;
                                    _statusText := STRING#'ERR_INVALID_EXTENDED_CMD';
                                    tempErrorInCmd := TRUE;
                                    tempNewExtendedCmd.%X1 := FALSE;

                                ELSIF (_torqueLimitingState = FIXED_STOP_DETECTION_ACTIVE)
                                THEN
                                    // Torquelimiting rejected because MC_TorqueLimiting is used during homing on fixed stop functionality
                                    _status := AxisStatus#ERR_TORQUE_LIMITING_NOT_ALLOWED;
                                    _statusText := STRING#'ERR_TORQUE_LIMITING_NOT_ALLOWED';
                                    tempErrorInCmd := TRUE;
                                    tempNewExtendedCmd.%X1 := FALSE;
                                    // ELSE
                                    //   ; // Start torquelimiting functionality
                                END_IF;
                            END_IF;

                            // Rising edge on passive homing command
                            IF (tempRisingCmd.%X2 = TRUE) THEN
                                tempNewExtendedCmd.%X2 := TRUE;
                                IF TRUE
                                    AND (_basicMotionState = ACTIVE_HOMING_SELECTED)
                                    AND ((_activeHomingState = HOMING_ON_FIXED_STOP) OR (_activeHomingState = HOMING_ON_FIXED_STOP_WITH_MOVING_OUT_OF_CLAMPING) OR (_activeHomingState = HOMING_ON_FIXED_STOP_WITH_MOVING_TO_TARGET_POSITION))
                                    AND (_exeOfBasicMotion = CMD_BUSY)
                                THEN
                                    // Passive Homing selected at homing on fixed stop
                                    _status := AxisStatus#ERR_HOMING_MODE_NOT_ALLOWED;
                                    _statusText := STRING#'ERR_HOMING_MODE_NOT_ALLOWED';
                                    tempErrorInCmd := TRUE;
                                    tempNewExtendedCmd.%X2 := FALSE;
                                    // ELSE
                                    //   ; // No error occurred
                                END_IF;
                            END_IF;
                        ELSE
                            ; // Error in basic motion command or superimposed motion command
                        END_IF;
                    END_IF;

                    // Enable commands
                    IF (tempErrorInCmd = TRUE) AND (tempStopCmdSelected = FALSE) THEN
                        // Error in current command - No Execution
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := WORD#0000;
                        _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                        // Write diagnostics
                        _diagnostics.basicMotionState := _basicMotionState;
                        _diagnostics.superimposedMotionState := _supImpMotionState;
                        _resetIncJog := TRUE;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                    ELSE
                        // No Error in command occurred
                        IF (
                            (tempNewExtendedCmd <> NO_SELECTION)
                            OR (tempNewBasicMotionCmd <> NO_SELECTION)
                            OR (tempNewSupImpCmd <> NO_SELECTION)
                            )
                            OR (tempStopCmdSelected = TRUE)
                        THEN

                            // New valid command selected
                            // Basic motion commands
                            IF (tempNewBasicMotionCmd <> NO_SELECTION) THEN
                                _mainSelectionState := CALL_BASIC_MOTION;

                                IF config.generalSettings.abortWaitingSyncCmd THEN
                                    // Get axis waiting function state
                                    IF (_typeAxis = SYNC_AXIS) THEN
                                        _waitingFunctionStateAbortAutomatic := _refSyncAxis^.StatusSynchronizedMotion.WaitingFunctionState;
                                    END_IF;

                                    CASE _waitingFunctionStateAbortAutomatic OF
                                        WFS_FS_GEARINPOS, // Waiting
                                        WFS_FS_CAMIN: // Waiting
                                            // Waiting sync command
                                            CASE tempNewBasicMotionCmd OF
                                                GEAR_IN_ABSOLUTE_SELECTED,
                                                GEAR_IN_VELOCITY_SELECTED,
                                                CAM_IN_SELECTED,
                                                GEAR_IN_RELATIVE_SELECTED,
                                                GEAR_OUT_CAM_OUT_SELECTED:
                                                    ; // New command aborts waiting sync command
                                            ELSE
                                                _mainSelectionState := ABORT_WAITING_GEARINPOS_OR_CAMIN; // Reset waiting absolute gearing / camIn command
                                            END_CASE;
                                    ELSE
                                        ;
                                    END_CASE;

                                    IF (_mainSelectionState = ABORT_WAITING_GEARINPOS_OR_CAMIN) THEN
                                        // Reset instance of MC_GearOut / MC_CamOut
                                        CASE _waitingFunctionStateAbortAutomatic OF
                                            WFS_FS_GEARINPOS: // Waiting
                                                _instGearOut(Slave := _refSyncAxis^,
                                                            Execute := FALSE,
                                                            SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING); // 5 = Abort waiting camming / gearing

                                            WFS_FS_CAMIN: // Waiting
                                                _instCamOut(Slave := _refSyncAxis^,
                                                            Execute := FALSE,
                                                            SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING); // 5 = Abort waiting camming / gearing
                                        END_CASE;
                                    END_IF;
                                ELSE
                                    // Automatic abort of waiting sync commands not enabled
                                    _waitingFunctionStateAbortAutomatic := -1;
                                END_IF;

                                _firstCycleBasicMotion := TRUE;
                                // Evaluate if Jog command is set
                                IF (tempNewBasicMotionCmd.%X2 = TRUE) OR (tempNewBasicMotionCmd.%X3 = TRUE) THEN
                                    _exeOfBasicMotion := CMD_BUSY;
                                    // Select Jogmode
                                    IF ((_basicCommand.%X2 = FALSE) AND (tempNewBasicMotionCmd.%X3 = TRUE)) OR // Rising edge at JogBackward and JogForward = FALSE
                                        ((_basicCommand.%X3 = FALSE) AND (tempNewBasicMotionCmd.%X2 = TRUE)) OR // Only rising edge at JogForward and JogBackward = FALSE
                                        ((tempNewBasicMotionCmd.%X2 = TRUE) AND (tempNewBasicMotionCmd.%X3 = TRUE)) // Rising edge at FW and BW
                                    THEN
                                        // One Input direction = False, other is rising edge, or both rising edge --> Start jog
                                        IF (_jogMode <> config.jog.mode) THEN
                                            _resetIncJog := TRUE;
                                        END_IF;
                                        _jogMode := config.jog.mode;
                                    ELSE
                                        // Rising edge at one input, the other is already TRUE - Dont Change Jogmode
                                        IF ((_basicMotionState = JOG_BACKWARD_SELECTED) OR (_basicMotionState = JOG_FORWARD_SELECTED)) AND (_jogMode <> JOG_MODE_CONTINUOUS)
                                        THEN
                                            _firstCycleBasicMotion := FALSE;
                                        END_IF;
                                    END_IF;
                                ELSE
                                    ; // Reset jog increment if other command than jog selected
                                    _resetIncJog := TRUE;
                                END_IF;

                                // Set new basic motion state
                                _basicMotionState := tempNewBasicMotionCmd;
                            END_IF;


                            // Superimposed motion commands
                            IF (tempNewSupImpCmd <> NO_SELECTION) THEN
                                _supImpMotionState := tempNewSupImpCmd;
                                _firstCycleSupImpMotion := TRUE;
                                _resetIncJog := TRUE;
                            END_IF;

                            // Extended commands

                            IF (tempNewExtendedCmd <> NO_SELECTION) THEN
                                IF (tempNewExtendedCmd.%X1 = TRUE) THEN
                                    // Rising edge on torquelimiting command
                                    IF (_torqueLimitingState = NO_TORQUE_LIMITING_ACTIVE) THEN
                                        // No torquelimiting active --> Enable torquelimiting
                                        _torqueLimitingState := TORQUE_LIMITING_SELECTED;
                                    END_IF;
                                END_IF;
                                // Homing command
                                IF (tempNewExtendedCmd.%X2 = TRUE) THEN
                                    _passiveHomingState := config.homing.extendedMode;
                                    _firstCycleHoming := TRUE;
                                    _resetIncJog := TRUE;
                                END_IF;
                            END_IF;

                        // Reset error
                        _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
                        _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
                        _errorAutoCleared := FALSE;
                        _diagnostics := _emptyDiagnostics;
                    // ELSE
                        //   ; // No rising edge at commands
                        END_IF;
                    END_IF;
                END_IF;

            AXIS_FAST_STOPPING:
                IF (config.fastStop.replaceStopPossible = FALSE) THEN
                    ; // Fast stop command can not be interrupted by another command
                    // State change is executed in FastStop implementation if command finished
                ELSE
                    _state := AXIS_MOTION;
                END_IF;

            AXIS_STOP_ON_ERROR_SELECTION,
            AXIS_STOP_ON_ERROR_EXECUTION:
                ; // Wait for stopping axis if StopOnError is configured
            FB_ERROR: // Error state
                ; // Do nothing, status already set

        ELSE
            // Errorhandling
            _status := AxisStatus#ERR_UNDEFINED_FB_STATE;
            _statusText := STRING#'ERR_UNDEFINED_FB_STATE';
            _errorUserCleared := TRUE;
            _diagnostics.subfunctionStatus := WORD#0000;
            _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
            _diagnostics.basicMotionState := _basicMotionState;
            _diagnostics.superimposedMotionState := _supImpMotionState;
            // Set error state
            _state := FB_ERROR;
        END_CASE;

        //----------------------------------------------------------------------------------------------
        // Execution of reset functionality
        //----------------------------------------------------------------------------------------------

        // Firstcycle of command
        IF (_extendedCommand.%X0 = TRUE) AND (_extendedCommandOld.%X0 = FALSE) THEN
            _firstCycleReset := TRUE;
            // Reset MC_RESET command
            _instReset(Axis := _refAxis^,
                       Execute := FALSE,
                       Restart := config.generalSettings.resetWithRestart);
            _firstCycleResetError := FALSE;
            _resetState := CMD_BUSY;
        END_IF;

        CASE _resetState OF
            CMD_IDLE:
                ; // Do nothing

            CMD_BUSY:
                // Call MC_Command
                _instReset(Axis := _refAxis^,
                           Execute := _extendedCommand.%X0);

                // Evaluate MC_Command
                IF (_instReset.Error = TRUE) THEN
                    // Errorhandling
                    IF (_firstCycleResetError = FALSE) THEN
                        _errorAutoCleared := TRUE;
                        _status := AxisStatus#ERR_MC_RESET;
                        _statusText := STRING#'ERR_MC_RESET';
                        _diagnostics.basicMotionState := _basicMotionState;
                        _diagnostics.superimposedMotionState := _supImpMotionState;
                        _diagnostics.subfunctionStatus := _instReset.ErrorId;
                        _subfunctionStatus := _instReset.ErrorId;
                        _firstCycleResetError := TRUE;
                        // Set next state
                        _resetState := CMD_IDLE;
                        IF (_state = AXIS_MOTION) THEN
                        // Set TO_STOP_ON_ERROR State only if the current state is TO_MOTION
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        END_IF;
                    END_IF;

                ELSIF (_instReset.Busy = FALSE) THEN
                    // Set next state
                    _resetState := CMD_IDLE;
                // ELSE
                //   ; // Command selected
                END_IF;
        ELSE
            // Errorhandling
            _status := AxisStatus#ERR_UNDEFINED_RESET_STATE;
            _statusText := STRING#'ERR_UNDEFINED_RESET_STATE';
            _errorUserCleared := TRUE;
            _diagnostics.subfunctionStatus := WORD#0000;
            _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
            _diagnostics.basicMotionState := _basicMotionState;
            _diagnostics.superimposedMotionState := _supImpMotionState;
        END_CASE;

        //----------------------------------------------------------------------------------------------
        // Execution of functionalities of basic coordinate system
        //----------------------------------------------------------------------------------------------

        // Write diagnostics
        _diagnostics.basicMotionState := _basicMotionState;
        _diagnostics.superimposedMotionState := _supImpMotionState;
        REPEAT
            tempStateChangeActive := FALSE;
            // Statemachine for main selection state
            CASE _mainSelectionState OF
                CALL_BASIC_MOTION:
                    CASE _basicMotionState OF
                        NO_SELECTION:
                            ; // No execution

                        FAST_STOP_SELECTED:
                            ; // Implementation at end of code

                        STOP_SELECTED:
                            // No additional features

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset HALT command
                                _instHalt(Axis := _refSpeedAxis^,
                                          Execute := FALSE,
                                          Deceleration := config.stop.deceleration,
                                          AbortAcceleration := config.stop.abortAcceleration,
                                          Jerk := config.stop.jerk,
                                          Mode := config.stop.haltMode); // New input 'Mode' as of Motion Control V9.0
                            END_IF;

                            // Call MC_Command
                            _instHalt(Axis := _refSpeedAxis^,
                                      Execute := _basicCommand.%X1 OR _firstCycleBasicMotion);

                            // Evaluate MC_Command
                            IF (_instHalt.Busy = FALSE) AND
                                (_instHalt.Error = FALSE) AND
                                (_instHalt.Done = FALSE) AND
                                (_instHalt.CommandAborted = FALSE)
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instHalt.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_HALT;
                                _statusText := STRING#'ERR_MC_HALT';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instHalt.ErrorId;
                                _subfunctionStatus := _instHalt.ErrorId;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                                //   ; // Command selected
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instHalt.Busy;
                            _exeOfBasicMotion.%X1 := _instHalt.Done;
                            _exeOfBasicMotion.%X2 := _instHalt.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instHalt.Error;

                        JOG_FORWARD_SELECTED, JOG_BACKWARD_SELECTED, JOG_FW_AND_BW_SELECTED:
                            // Additional features (applicative): Jog mode incremental

                            CASE _jogMode OF
                                JOG_MODE_CONTINUOUS:

                                    // No additional feature
                                    // Firstcycle of command
                                    IF (_firstCycleBasicMotion = TRUE) THEN
                                        // Copy no dynamics into static variables because changes are accepted by MC_MoveJog immediately (enable)
                                        _instMoveJog(Axis := _refSpeedAxis^,
                                                     JogForward := FALSE,
                                                     JogBackward := FALSE);
                                    END_IF;

                                    // Call MC_Command
                                    _instMoveJog(Axis := _refSpeedAxis^,
                                                 JogForward := _basicCommand.%X2,
                                                 JogBackward := _basicCommand.%X3,
                                                 Velocity := config.jog.velocity,
                                                 Acceleration := config.jog.acceleration,
                                                 Deceleration := config.jog.deceleration,
                                                 PositionControlled := config.jog.positionControlled,
                                                 Jerk := config.jog.jerk);

                                    // Evaluate MC_Command
                                    IF (_instMoveJog.Busy = FALSE) AND
                                        (_instMoveJog.Error = FALSE) AND
                                        (_instMoveJog.CommandAborted = FALSE) AND
                                        (_instMoveJog.InVelocity = FALSE)
                                    THEN
                                        // Return to NO_SELECTION if command finished
                                        _basicMotionState := NO_SELECTION;

                                    ELSIF (_instMoveJog.Error = TRUE) THEN
                                        // Errorhandling
                                        _status := AxisStatus#ERR_MC_MOVEJOG;
                                        _statusText := STRING#'ERR_MC_MOVEJOG';
                                        _errorAutoCleared := TRUE;
                                        _diagnostics.subfunctionStatus := _instMoveJog.ErrorId;
                                        _subfunctionStatus := _instMoveJog.ErrorId;
                                        // Set next state
                                        _basicMotionState := NO_SELECTION;
                                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                                        // ELSE
                                        //   ; // Command selected
                                    END_IF;

                                    // Write MC_Command outputs to internal variable
                                    _exeOfBasicMotion := 16#0;
                                    _exeOfBasicMotion.%X0 := _instMoveJog.Busy;
                                    _exeOfBasicMotion.%X2 := _instMoveJog.CommandAborted;
                                    _exeOfBasicMotion.%X3 := _instMoveJog.Error;
                                    _exeOfBasicMotion.%X4 := _instMoveJog.InVelocity;

                                JOG_MODE_CONTINUE_INCREMENT, JOG_MODE_NEW_INCREMENT:

                                    // This case is additional feature (MC_MOVERELATIVE and MC_HALT internal used)
                                    CASE _exeOfBasicMotion OF
                                        CMD_BUSY:
                                            // Firstcycle of command
                                            IF (_firstCycleBasicMotion = TRUE) THEN // New rising edge at JogForward or JogBackward
                                                // Check for only one Jog direction selected (Forward OR Backward)
                                                IF (_basicCommand.%X2 XOR _basicCommand.%X3) // Only one direction selected
                                                THEN
                                                    // Reset MOVERELATIVE command
                                                    _instMoveRelative(Axis := _refPosAxis^,
                                                                      Execute := FALSE);
                                                    // Reset HALT command
                                                    _instHalt(Axis := _refSpeedAxis^,
                                                              Execute := FALSE);

                                                    // Set new Increment if direction changed necessary
                                                    IF (_resetIncJog = FALSE) THEN
                                                        IF ((_incJogDirectionOld = FORWARD_DIR) AND (_basicCommand.%X2 = TRUE)) OR
                                                            ((_incJogDirectionOld = BACKWARD_DIR) AND (_basicCommand.%X3 = TRUE))
                                                        THEN
                                                            ; // Direction of last jog process same as current --> continue Jog
                                                        ELSE
                                                            _resetIncJog := TRUE;
                                                        END_IF;
                                                    END_IF;

                                                    // Determine distance for positioning command (relative)
                                                    IF (config.jog.mode = JOG_MODE_NEW_INCREMENT) // In this mode a new increment is always set
                                                        OR ((config.jog.mode = JOG_MODE_CONTINUE_INCREMENT) AND (_resetIncJog = TRUE))
                                                    THEN
                                                        _resetIncJog := FALSE;
                                                        // New increment
                                                        IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                            _incJogStartPosition := _refPosAxis^.Position;
                                                        ELSE // Invalid TO specification
                                                            _incJogStartPosition := 0.0;
                                                        END_IF;
                                                        _increment := Abs(config.jog.increment); // absolute Distance for increment
                                                        IF (_basicCommand.%X2 = TRUE) THEN
                                                            // JogForward selected
                                                            _position := Abs(config.jog.increment);
                                                            _increment := _position;
                                                            _incJogDirectionOld := FORWARD_DIR;
                                                        ELSIF (_basicCommand.%X3 = TRUE) THEN
                                                            // JogBackward selected
                                                            _position := -Abs(config.jog.increment);
                                                            _increment := _position;
                                                            _incJogDirectionOld := BACKWARD_DIR;
                                                        ELSE
                                                            // Normal not possible to reach ELSE-branch
                                                            _incJogDirectionOld := 0;
                                                        END_IF;
                                                    ELSE
                                                        // Check for modulo axis
                                                        IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                            tempBool := _refPosAxis^.Modulo.Enable;
                                                        ELSE // Invalid TO specification
                                                            tempBool := FALSE;
                                                        END_IF;

                                                        IF (tempBool = FALSE) THEN
                                                            // No Modulo enabled
                                                            // Continue increment
                                                            IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                                tempLReal := _refPosAxis^.Position;
                                                            ELSE // Invalid TO specification
                                                                tempLReal := 0.0;
                                                            END_IF;

                                                            _position := (_incJogStartPosition + _increment) - tempLReal;
                                                            // Distance := setpoint - actualvalue
                                                        ELSE
                                                            // Modulo enabled
                                                            _position := _incJogDistance;
                                                        END_IF;
                                                    END_IF;
                                                    _incJogSubState := INC_JOG_START;

                                                    // Store Dynamics
                                                    _basicVelocity := Abs(config.jog.velocity);
                                                    _basicAcceleration := config.jog.acceleration;
                                                    _basicDeceleration := config.jog.deceleration;
                                                    _basicJerk := config.jog.jerk;
                                                ELSE
                                                    // Errorhandling - Invalid direction (forward and backward selected)
                                                    _status := AxisStatus#ERR_INVALID_JOG_DIR;
                                                    _statusText := STRING#'ERR_INVALID_JOG_DIR';
                                                    _errorAutoCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    _diagnostics.basicMotionState := _basicMotionState;
                                                    // Set next state
                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                    _basicMotionState := NO_SELECTION;
                                                    _exeOfBasicMotion := CMD_ERROR;
                                                    _incJogSubState := INC_JOG_IDLE;
                                                END_IF;

                                            ELSIF ((_basicCommand.%X2 = FALSE) AND (_basicCommand.%X3 = FALSE)) // No jog input selected --> Stop moving
                                                AND (_incJogSubState <> INC_JOG_STOP)
                                            THEN
                                                // Reset HALT command
                                                _instHalt(Axis := _refSpeedAxis^,
                                                          Execute := FALSE);
                                                _incJogSubState := INC_JOG_STOP;
                                                IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                    _incJogDistance := _refPosAxis^.StatusPositioning.Distance;
                                                ELSE // Invalid TO specification
                                                    _incJogDistance := 0.0;
                                                END_IF;

                                            ELSIF (_basicCommand.%X2 = TRUE) AND (_basicCommand.%X3 = TRUE) // jogForward and jogBackward selected - Error
                                            THEN
                                                // Reset HALT command
                                                _instHalt(Axis := _refSpeedAxis^,
                                                         Execute := FALSE);
                                                _incJogSubState := INC_JOG_STOP;
                                                // Errorhandling
                                                _status := AxisStatus#ERR_INVALID_JOG_DIR;
                                                _statusText := STRING#'ERR_INVALID_JOG_DIR';
                                                _errorAutoCleared := TRUE;
                                                _diagnostics.subfunctionStatus := WORD#0000;
                                                _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                // Set next state
                                                _exeOfBasicMotion := CMD_ERROR;
                                                _basicMotionState := NO_SELECTION;
                                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                            // ELSE
                                                //   ; // Command running
                                            END_IF;

                                            // Select motion
                                            CASE _incJogSubState OF
                                                INC_JOG_IDLE:
                                                    ; // Do nothing - Error occurred (jogforward and jogbackward are set in firstCycle of operation)

                                                INC_JOG_START: // Run jog operation --> Motion stops automatically if increment complete
                                                    _instMoveRelative(Axis := _refPosAxis^,
                                                                    Execute := TRUE,
                                                                    Distance := _position,
                                                                    Velocity := _basicVelocity,
                                                                    Acceleration := _basicAcceleration,
                                                                    Deceleration := _basicDeceleration,
                                                                    Jerk := _basicJerk);

                                                // Evaluate MC_Command
                                                IF (_instMoveRelative.Done = TRUE) THEN
                                                    // Increment completed
                                                    _resetIncJog := TRUE;
                                                    // Set next state
                                                    _exeOfBasicMotion := CMD_DONE;
                                                    _incJogSubState := INC_JOG_IDLE;

                                                ELSIF (_instMoveRelative.Error = TRUE) THEN
                                                    _resetIncJog := TRUE;
                                                    // Errorhandling
                                                    _status := AxisStatus#ERR_MC_MOVERELATIVE;
                                                    _statusText := STRING#'ERR_MC_MOVERELATIVE';
                                                    _errorAutoCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := _instMoveRelative.ErrorId;
                                                    _subfunctionStatus := _instMoveRelative.ErrorId;
                                                    // Set next state
                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                    _basicMotionState := NO_SELECTION;
                                                    _exeOfBasicMotion := CMD_ERROR;
                                                    _incJogSubState := INC_JOG_IDLE;

                                                ELSIF (_instMoveRelative.CommandAborted = TRUE) THEN
                                                    _resetIncJog := TRUE;
                                                    _exeOfBasicMotion := CMD_ABORTED;
                                                    _incJogSubState := INC_JOG_IDLE;
                                                    // ELSE
                                                    //   ; // Wait for next state
                                                END_IF;

                                                INC_JOG_STOP: // Executed if inputs are reset --> Stop jog operation OR if jogForward and jogBackward are set --> Error and stop axis
                                                    _instHalt(Axis := _refSpeedAxis^,
                                                              Execute := TRUE,
                                                              Deceleration := _basicDeceleration,
                                                              AbortAcceleration := FALSE,
                                                              Jerk := _basicJerk,
                                                              Mode := 0); // Mode := 0 "The basic motion and the superimposed motion are stopped." MC_Halt instance is also used for input 'stop', where the 'haltMode' can now be specified via config

                                                    // Evaluate MC_Command
                                                    IF (_instHalt.Done = TRUE) THEN
                                                        // Set next state
                                                        _exeOfBasicMotion := CMD_END_PROCESS;
                                                        _incJogSubState := INC_JOG_IDLE;

                                                    ELSIF (_instHalt.Error = TRUE) THEN
                                                        _resetIncJog := TRUE;
                                                        // Errorhandling
                                                        _status := AxisStatus#ERR_MC_HALT;
                                                        _statusText := STRING#'ERR_MC_HALT';
                                                        _errorAutoCleared := TRUE;
                                                        _diagnostics.subfunctionStatus := _instHalt.ErrorId;
                                                        _subfunctionStatus := _instHalt.ErrorId;
                                                        // Set next state
                                                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                        _basicMotionState := NO_SELECTION;
                                                        _exeOfBasicMotion := CMD_ERROR;
                                                        _incJogSubState := INC_JOG_IDLE;

                                                    ELSIF (_instHalt.CommandAborted = TRUE) THEN
                                                        _resetIncJog := TRUE;
                                                        // Set next state
                                                        _incJogSubState := INC_JOG_IDLE;
                                                        _exeOfBasicMotion := CMD_ABORTED;
                                                    // ELSE
                                                        //   ; // Wait for stopping axis
                                                    END_IF;
                                                ELSE
                                                    // Errorhandling
                                                    _status := AxisStatus#ERR_UNDEFINED_INCREMENTAL_JOG_SUBSTATE;
                                                    _statusText := STRING#'ERR_UNDEFINED_INCREMENTAL_JOG_SUBSTATE';
                                                    _errorUserCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    // Set errorstate
                                                    _state := FB_ERROR;
                                                END_CASE;

                                        CMD_DONE,
                                        CMD_ABORTED,
                                        CMD_ERROR,
                                        CMD_END_PROCESS:
                                            // Return to NO_SELECTION if command finished
                                            IF (_basicCommand.%X2 = FALSE) AND (_basicCommand.%X3 = FALSE) THEN
                                                // jogForward and jogbackward inputs are reset
                                                _exeOfBasicMotion := CMD_BUSY;
                                                _basicMotionState := NO_SELECTION;
                                            // ELSE
                                                //   ; // Wait for falling edge at inputs for jog
                                            END_IF;
                                    ELSE
                                        // Errorhandling
                                        _status := AxisStatus#ERR_UNDEFINED_INCREMENTAL_JOG_STATE;
                                        _statusText := STRING#'ERR_UNDEFINED_INCREMENTAL_JOG_STATE';
                                        _errorUserCleared := TRUE;
                                        _diagnostics.subfunctionStatus := WORD#0000;
                                        _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                        _diagnostics.basicMotionState := _basicMotionState;
                                        // Set errorstate
                                        _state := FB_ERROR;
                                    END_CASE;

                            ELSE
                                // Errorhandling - Invalid jog state
                                _status := AxisStatus#ERR_INVALID_JOG_MODE;
                                _statusText := STRING#'#ERR_INVALID_JOG_MODE';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := WORD#0000;
                                _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            END_CASE;

                        MOVE_VELOCITY_SELECTED:
                            // Additional features (applicative): Change setpoint on the fly (Velocity)

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset MC_MOVEVELOCITY command
                                _instMoveVelocity(Axis := _refSpeedAxis^,
                                                    Execute := FALSE);

                                _velocityChangeOnTheFly := config.moveVelocity.velocityChangeOnTheFly;

                                _instMoveVelocity.Velocity := config.moveVelocity.velocity;
                                _basicVelocity := config.moveVelocity.velocity;

                                _instMoveVelocity.Acceleration := config.moveVelocity.acceleration;
                                _instMoveVelocity.Deceleration := config.moveVelocity.deceleration;
                                _instMoveVelocity.Jerk := config.moveVelocity.jerk;
                                _instMoveVelocity.Direction := config.moveVelocity.direction;
                                _instMoveVelocity.PositionControlled := config.moveVelocity.positionControlled;
                                _instMoveVelocity.Current := FALSE;

                            ELSIF (_velocityChangeOnTheFly = TRUE) AND (config.moveVelocity.velocity <> _basicVelocity) // Velocity changed
                                AND (_instMoveVelocity.CommandAborted = FALSE)
                            THEN
                                // Reset MC_MOVEVELOCITY command
                                _instMoveVelocity(Axis := _refSpeedAxis^,
                                                Execute := FALSE);

                                _instMoveVelocity.Velocity := config.moveVelocity.velocity;
                                _basicVelocity := config.moveVelocity.velocity;

                                // Copy also dynamics
                                _instMoveVelocity.Acceleration := config.moveVelocity.acceleration;
                                _instMoveVelocity.Deceleration := config.moveVelocity.deceleration;
                                _instMoveVelocity.Jerk := config.moveVelocity.jerk;
                                _instMoveVelocity.Direction := config.moveVelocity.direction;
                                _instMoveVelocity.PositionControlled := config.moveVelocity.positionControlled;
                            END_IF;

                            // Call MC_Command
                            _instMoveVelocity(Axis := _refSpeedAxis^,
                                              Execute := _basicCommand.%X4 OR _firstCycleBasicMotion); // Input: moveVelocity

                            // Evaluate MC_Command
                            IF (_instMoveVelocity.Busy = FALSE) AND
                                (_instMoveVelocity.Error = FALSE) AND
                                (_instMoveVelocity.CommandAborted = FALSE) AND
                                (_instMoveVelocity.InVelocity = FALSE)
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instMoveVelocity.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_MOVEVELOCITY;
                                _statusText := STRING#'ERR_MC_MOVEVELOCITY';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instMoveVelocity.ErrorId;
                                _subfunctionStatus := _instMoveVelocity.ErrorId;
                                _velocityChangeOnTheFly := FALSE;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                                // ELSE
                                //   ; // Command selected
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instMoveVelocity.Busy;
                            _exeOfBasicMotion.%X2 := _instMoveVelocity.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instMoveVelocity.Error;
                            _exeOfBasicMotion.%X4 := _instMoveVelocity.InVelocity;

                        POS_RELATIVE_SELECTED:
                            // Additional features (applicative): Specified direction

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Configurate the direction of rotation
                                IF ((config.posRelative.direction = 0) AND (config.posRelative.distance >= 0.0)) // Sign of distance is evaluated
                                    OR (config.posRelative.direction = FORWARD_DIR) // Forward direction
                                THEN
                                    _position := Abs(config.posRelative.distance);
                                    // Reset MC_MOVERELATIVE command
                                    _instMoveRelative(Axis := _refPosAxis^,
                                                      Execute := FALSE,
                                                      Distance := _position,
                                                      Velocity := config.posRelative.velocity,
                                                      Acceleration := config.posRelative.acceleration,
                                                      Deceleration := config.posRelative.deceleration,
                                                      Jerk := config.posRelative.jerk);
                                    _applicativeBasicMotionError := FALSE;

                                ELSIF ((config.posRelative.direction = 0) AND (config.posRelative.distance < 0.0)) // Sign of distance is evaluated
                                    OR (config.posRelative.direction = BACKWARD_DIR) // Backward direction
                                THEN
                                    _position := -Abs(config.posRelative.distance);
                                    // Reset MC_MOVERELATIVE command
                                    _instMoveRelative(Axis := _refPosAxis^,
                                                      Execute := FALSE,
                                                      Distance := _position,
                                                      Velocity := config.posRelative.velocity,
                                                      Acceleration := config.posRelative.acceleration,
                                                      Deceleration := config.posRelative.deceleration,
                                                      Jerk := config.posRelative.jerk);

                                    _applicativeBasicMotionError := FALSE;
                                ELSE
                                    // Errorhandling - Invalid direction
                                    _status := AxisStatus#ERR_INVALID_POS_RELATIVE_DIR;
                                    _statusText := STRING#'ERR_INVALID_POS_RELATIVE_DIR';
                                    _errorAutoCleared := TRUE;
                                    _diagnostics.subfunctionStatus := WORD#0000;
                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                    _applicativeBasicMotionError := TRUE;
                                    // Set next state
                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                    _basicMotionState := NO_SELECTION;
                                END_IF;
                            END_IF;

                            IF (_applicativeBasicMotionError = FALSE) THEN
                                // Call MC_Command
                                _instMoveRelative(Axis := _refPosAxis^,
                                                  Execute := _basicCommand.%X5 OR _firstCycleBasicMotion); // Input: posRelative

                                // Evaluate MC_Command
                                IF (_instMoveRelative.Busy = FALSE) AND
                                    (_instMoveRelative.Error = FALSE) AND
                                    (_instMoveRelative.Done = FALSE) AND
                                    (_instMoveRelative.CommandAborted = FALSE)
                                THEN
                                    // Return to NO_SELECTION if command finished
                                    _basicMotionState := NO_SELECTION;

                                ELSIF (_instMoveRelative.Error = TRUE) THEN
                                    // Errorhandling
                                    _status := AxisStatus#ERR_MC_MOVERELATIVE;
                                    _statusText := STRING#'ERR_MC_MOVERELATIVE';
                                    _errorAutoCleared := TRUE;
                                    _diagnostics.subfunctionStatus := _instMoveRelative.ErrorId;
                                    _subfunctionStatus := _instMoveRelative.ErrorId;
                                    // Set next state
                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                    _basicMotionState := NO_SELECTION;
                                // ELSE
                                    //   ; // Command selected
                                END_IF;

                                // Write MC_Command outputs to internal variable
                                _exeOfBasicMotion := 16#0;
                                _exeOfBasicMotion.%X0 := _instMoveRelative.Busy;
                                _exeOfBasicMotion.%X1 := _instMoveRelative.Done;
                                _exeOfBasicMotion.%X2 := _instMoveRelative.CommandAborted;
                                _exeOfBasicMotion.%X3 := _instMoveRelative.Error;
                            // ELSE
                                //   ; // Direction not valid
                            END_IF;

                        POS_ABSOLUTE_SELECTED:
                            // Additional features (applicative): Change setpoint on the fly (Velocity and Position)

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset MC_MOVEABSOLUTE command
                                _instMoveAbsolute(Axis := _refPosAxis^,
                                                  Execute := FALSE);

                                _instMoveAbsolute.Position := config.posAbsolute.position;
                                _position := config.posAbsolute.position;
                                _instMoveAbsolute.Velocity := config.posAbsolute.velocity;
                                _basicVelocity := config.posAbsolute.velocity;

                                _instMoveAbsolute.Acceleration := config.posAbsolute.acceleration;
                                _instMoveAbsolute.Deceleration := config.posAbsolute.deceleration;
                                _instMoveAbsolute.Jerk := config.posAbsolute.jerk;
                                _instMoveAbsolute.Direction := config.posAbsolute.direction;

                                _velocityChangeOnTheFly := config.posAbsolute.velocityChangeOnTheFly;
                                _positionChangeOnTheFly := config.posAbsolute.positionChangeOnTheFly;

                            ELSIF (((_velocityChangeOnTheFly = TRUE) AND (config.posAbsolute.velocity <> _basicVelocity))
                                OR ((_positionChangeOnTheFly = TRUE) AND (config.posAbsolute.position <> _position)))
                                AND (_instMoveAbsolute.CommandAborted = FALSE)
                            THEN
                                // Reset MC_MOVEABSOLUTE command
                                _instMoveAbsolute(Axis := _refPosAxis^,
                                                  Execute := FALSE);

                                IF (_velocityChangeOnTheFly = TRUE) THEN // Apply the new velocity value
                                    _instMoveAbsolute.Velocity := config.posAbsolute.velocity;
                                    _basicVelocity := config.posAbsolute.velocity;

                                    // Copy also dynamics
                                    _instMoveAbsolute.Acceleration := config.posAbsolute.acceleration;
                                    _instMoveAbsolute.Deceleration := config.posAbsolute.deceleration;
                                    _instMoveAbsolute.Jerk := config.posAbsolute.jerk;
                                    _instMoveAbsolute.Direction := config.posAbsolute.direction;
                                END_IF;

                                IF (_positionChangeOnTheFly = TRUE) THEN // Apply the new position value
                                    _instMoveAbsolute.Position := config.posAbsolute.position;
                                    _position := config.posAbsolute.position;

                                    // Copy also dynamics
                                    _instMoveAbsolute.Velocity := config.posAbsolute.velocity;
                                    _instMoveAbsolute.Acceleration := config.posAbsolute.acceleration;
                                    _instMoveAbsolute.Deceleration := config.posAbsolute.deceleration;
                                    _instMoveAbsolute.Jerk := config.posAbsolute.jerk;
                                    _instMoveAbsolute.Direction := config.posAbsolute.direction;
                                END_IF;
                            END_IF;

                            _instMoveAbsolute(Axis := _refPosAxis^,
                                              Execute := _basicCommand.%X6 OR _firstCycleBasicMotion); // Input: posAbsolute

                            // Evaluate MC_Command
                            IF (_instMoveAbsolute.Busy = FALSE) AND
                                (_instMoveAbsolute.Error = FALSE) AND
                                (_instMoveAbsolute.Done = FALSE) AND
                                (_instMoveAbsolute.CommandAborted = FALSE)
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instMoveAbsolute.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_MOVEABSOLUTE;
                                _statusText := STRING#'ERR_MC_MOVEABSOLUTE';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instMoveAbsolute.ErrorId;
                                _subfunctionStatus := _instMoveAbsolute.ErrorId;
                                _velocityChangeOnTheFly := FALSE;
                                _positionChangeOnTheFly := FALSE;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instMoveAbsolute.Busy;
                            _exeOfBasicMotion.%X1 := _instMoveAbsolute.Done;
                            _exeOfBasicMotion.%X2 := _instMoveAbsolute.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instMoveAbsolute.Error;

                        ACTIVE_HOMING_SELECTED:
                            // Additional feature (applicative): homing on fixed stop

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                _activeHomingState := config.homing.extendedMode;
                                _exeOfBasicMotion := CMD_BUSY;
                                _passiveHomingState := NO_HOMING_ACTIVE;
                            END_IF;

                            // Selection of extended homing mode
                            CASE _activeHomingState OF
                                STANDARD_HOMING:
                                    // No additional features

                                    // Firstcycle of command
                                    IF (_firstCycleBasicMotion = TRUE) THEN
                                        // Reset MC_HOME command
                                        _instHome(Axis := _refAxis^,
                                                  Execute := FALSE,
                                                  Position := config.homing.position,
                                                  Mode := config.homing.mode,
                                                  Sensor := config.homing.sensor);
                                    END_IF;

                                    // Call MC_Command

                                    _instHome(Axis := _refAxis^,
                                              Execute := _basicCommand.%X10 OR _firstCycleBasicMotion); // Input: homing

                                    // Evaluate MC_Command
                                    IF (_instHome.Busy = FALSE) AND
                                        (_instHome.Done = FALSE) AND
                                        (_instHome.CommandAborted = FALSE) AND
                                        (_instHome.Error = FALSE)
                                    THEN
                                        // Return to NO_SELECTION if command finished
                                        _activeHomingState := STANDARD_HOMING;
                                        _basicMotionState := NO_SELECTION;

                                    ELSIF (_instHome.Error = TRUE) THEN
                                        // Errorhandling
                                        _status := AxisStatus#ERR_MC_HOME;
                                        _statusText := STRING#'ERR_MC_HOME';
                                        _errorAutoCleared := TRUE;
                                        _diagnostics.subfunctionStatus := _instHome.ErrorId;
                                        _subfunctionStatus := _instHome.ErrorId;
                                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                                        _basicMotionState := NO_SELECTION;
                                        // ELSE
                                        //   ; // Command selected
                                    END_IF;

                                    _exeOfBasicMotion := 16#0;
                                    _exeOfBasicMotion.%X0 := _instHome.Busy;
                                    _exeOfBasicMotion.%X1 := _instHome.Done;
                                    _exeOfBasicMotion.%X2 := _instHome.CommandAborted;
                                    _exeOfBasicMotion.%X3 := _instHome.Error;


                                HOMING_ON_FIXED_STOP,
                                HOMING_ON_FIXED_STOP_WITH_MOVING_OUT_OF_CLAMPING,
                                HOMING_ON_FIXED_STOP_WITH_MOVING_TO_TARGET_POSITION:
                                    // This case is additional feature (MC_MOVEVELOCITY and MC_HOME internal used)

                                    CASE _exeOfBasicMotion OF
                                        CMD_BUSY:
                                            // Firstcycle of command
                                            IF (_firstCycleBasicMotion = TRUE) THEN

                                                // Read operative sensor
                                                IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                    tempIndex := TO_INT(_refPosAxis^.OperativeSensor);
                                                ELSE // Invalid TO specification
                                                    tempIndex := 1;
                                                END_IF;

                                                IF (tempIndex < 1) THEN
                                                    tempIndex := 1;
                                                END_IF;

                                                IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                    tempDInt := _refPosAxis^.Sensor[tempIndex].ActiveHoming.Direction;
                                                ELSE // Invalid TO specification
                                                    tempDInt := 0; // Positive direction
                                                END_IF;

                                                IF (tempDInt = 0)
                                                THEN
                                                    // Positive direction
                                                    _direction := FORWARD_DIR;
                                                ELSE
                                                    // Negative direction
                                                    _direction := BACKWARD_DIR;
                                                END_IF;

                                                // Check if homing on fixed stop is allowed

                                                IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                    tempBool := _refPosAxis^.Modulo.Enable;
                                                    tempLReal := _refPosAxis^.Homing.ReferencingVelocity;
                                                ELSE // Invalid TO specification
                                                    tempBool := FALSE;
                                                    tempLReal := 0.0;
                                                END_IF;

                                                IF (tempBool = TRUE) THEN
                                                    // Modulo enabled - Errorhandling
                                                    _status := AxisStatus#ERR_MODULO_NOT_ALLOWED;
                                                    _statusText := STRING#'ERR_MODULO_NOT_ALLOWED';
                                                    _errorAutoCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    _diagnostics.basicMotionState := _basicMotionState;
                                                    // Set next state
                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                    _basicMotionState := NO_SELECTION;
                                                    _activeHomingState := STANDARD_HOMING;
                                                    _homingSubState := HOMING_IDLE;

                                                ELSIF (config.homing.extendedModeTorqueLimit = 0.0) // Torque limit 0.0 in config
                                                THEN
                                                    // Errorhandling -  Torque value 0.0 configured
                                                    _status := AxisStatus#ERR_INVALID_TORQUE_LIMIT;
                                                    _statusText := STRING#'ERR_INVALID_TORQUE_LIMIT';
                                                    _errorAutoCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    _diagnostics.basicMotionState := _basicMotionState;
                                                    // Set next state
                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                    _basicMotionState := NO_SELECTION;
                                                    _activeHomingState := STANDARD_HOMING;
                                                    _homingSubState := HOMING_IDLE;

                                                ELSIF (tempLReal = 0.0)
                                                THEN
                                                    // Errorhandling -  Velocity 0 configured
                                                    _status := AxisStatus#ERR_INVALID_VELOCITY;
                                                    _statusText := STRING#'ERR_INVALID_VELOCITY';
                                                    _errorAutoCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    _diagnostics.basicMotionState := _basicMotionState;
                                                    // Set next state
                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                    _basicMotionState := NO_SELECTION;
                                                    _activeHomingState := STANDARD_HOMING;
                                                    _homingSubState := HOMING_IDLE;

                                                ELSIF (_activeHomingState = HOMING_ON_FIXED_STOP_WITH_MOVING_TO_TARGET_POSITION) // condition modified (check target pos. only if extendedMode = 2)
                                                    AND
                                                    ((config.homing.extendedModeTargetPosition > config.homing.position) AND (_direction = FORWARD_DIR)
                                                    OR (config.homing.extendedModeTargetPosition < config.homing.position) AND (_direction = BACKWARD_DIR))
                                                THEN
                                                    // Errorhandling -  Invalid target position for extended homing mode "2: Homing on fixed stop with moving to target position"
                                                    _status := AxisStatus#ERR_INVALID_TARGET_POSITION;
                                                    _statusText := STRING#'ERR_INVALID_TARGET_POSITION';
                                                    _errorAutoCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    _diagnostics.basicMotionState := _basicMotionState;
                                                    // Set next state
                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                    _basicMotionState := NO_SELECTION;
                                                    _activeHomingState := STANDARD_HOMING;
                                                    _homingSubState := HOMING_IDLE;

                                                ELSE
                                                    // Store dynamic values
                                                    _homingPosition := config.homing.position;
                                                    _basicVelocity := tempLReal;
                                                    IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                        _basicAcceleration := _refPosAxis^.DynamicDefaults.Acceleration;
                                                        _basicDeceleration := _refPosAxis^.DynamicDefaults.Deceleration;
                                                        _basicJerk := _refPosAxis^.DynamicDefaults.Jerk;
                                                    ELSE // Invalid TO specification
                                                        _basicAcceleration := -1.0;
                                                        _basicDeceleration := -1.0;
                                                        _basicJerk := 0.0; // No Jerk
                                                    END_IF;

                                                    _torqueLimitingState := FIXED_STOP_DETECTION_ACTIVE;
                                                    // Reset MC_Commands
                                                    _instHome(Axis := _refAxis^,
                                                              Execute := FALSE,
                                                              Position := _homingPosition,
                                                              //  Mode := statHomingMode,
                                                              Sensor := 0);

                                                    _instMoveVelocity(Axis := _refSpeedAxis^,
                                                                      Execute := FALSE,
                                                                      Velocity := _basicVelocity,
                                                                      Acceleration := _basicAcceleration,
                                                                      Deceleration := _basicDeceleration,
                                                                      Jerk := _basicJerk,
                                                                      PositionControlled := TRUE,
                                                                      Direction := _direction);

                                                    _instMoveAbsolute(Axis := _refPosAxis^,
                                                                      Execute := FALSE,
                                                                      Velocity := Abs(_basicVelocity),
                                                                      Acceleration := _basicAcceleration,
                                                                      Deceleration := _basicDeceleration,
                                                                      Jerk := _basicJerk);

                                                    // Determine the encoder type
                                                    IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                        tempDInt := _refPosAxis^.Sensor[tempIndex]._Type;
                                                    ELSE // Invalid TO specification
                                                        tempDInt := 0; // Incremental
                                                    END_IF;

                                                    IF (tempDInt = INCREMENTAL_ENCODER) THEN
                                                        _instHome.Mode := DIRECT_HOMING; // Direct homing (absolute)
                                                    ELSE
                                                        _instHome.Mode := ABSOLUTE_ENCODER_ADJUSTMENT;
                                                    END_IF;
                                                    // Use always direct homing
                                                    //#statHomingMode := DIRECT_HOMING; // Direct homing (absolute)
                                                    // Set next state
                                                    _homingSubState := HOMING_FIXED_STOP_DETECTION;
                                                END_IF;
                                            END_IF;

                                            // Call of subStateMachine
                                            REPEAT
                                                CASE _homingSubState OF
                                                    HOMING_IDLE:
                                                        tempStateChangeActive := FALSE;
                                                        // Do nothing, no execution of homing if error occurred in first cycle

                                                    HOMING_FIXED_STOP_DETECTION:
                                                        tempStateChangeActive := FALSE;

                                                        // Start axis to detect fixed stop
                                                        _instMoveVelocity(Axis := _refSpeedAxis^,
                                                                        Execute := TRUE);

                                                        // Evaluate MC_Command
                                                        IF (tempStatusWord.%X30 = TRUE) THEN // inClamping = TRUE
                                                            // Fixed stop detected --> start homing process
                                                            _homingSubState := HOMING_PROCESS;
                                                            tempStateChangeActive := TRUE;

                                                        ELSIF (_instMoveVelocity.Error = TRUE) THEN
                                                            // Errorhandling
                                                            _status := AxisStatus#ERR_MC_MOVEVELOCITY;
                                                            _statusText := STRING#'ERR_MC_MOVEVELOCITY';
                                                            _errorAutoCleared := TRUE;
                                                            _diagnostics.subfunctionStatus := _instMoveVelocity.ErrorId;
                                                            _subfunctionStatus := _instMoveVelocity.ErrorId;
                                                            // Set next state
                                                            _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                            _basicMotionState := NO_SELECTION;
                                                            _activeHomingState := STANDARD_HOMING;
                                                            _exeOfBasicMotion := CMD_ERROR;
                                                            _homingSubState := HOMING_IDLE;

                                                        ELSIF (_instMoveVelocity.CommandAborted = TRUE) THEN
                                                            // Set next state
                                                            _exeOfBasicMotion := CMD_ABORTED;
                                                            _homingSubState := HOMING_IDLE;
                                                        // ELSE
                                                            //   ;// Wait for detecting fixed stop
                                                        END_IF;

                                                    HOMING_PROCESS:
                                                        tempStateChangeActive := FALSE;
                                                        // Execute MC_HOME
                                                        _instHome(Axis := _refAxis^,
                                                                Execute := TRUE);

                                                        // Evaluate MC_Command
                                                        IF (_instHome.Done = TRUE) THEN
                                                            // MC_HOME finished - Set next state
                                                            _homingSubState := HOMING_POSITION;
                                                            tempStateChangeActive := TRUE;

                                                        ELSIF (_instHome.Error = TRUE) THEN
                                                            // Errorhandling
                                                            _status := AxisStatus#ERR_MC_HOME;
                                                            _statusText := STRING#'ERR_MC_HOME';
                                                            _errorAutoCleared := TRUE;
                                                            _diagnostics.subfunctionStatus := _instHome.ErrorId;
                                                            _subfunctionStatus := _instHome.ErrorId;
                                                            // Set next state
                                                            _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                            _exeOfBasicMotion := CMD_ERROR;
                                                            _homingSubState := HOMING_IDLE;

                                                        ELSIF (_instHome.CommandAborted = TRUE) THEN
                                                            // Set next state
                                                            _exeOfBasicMotion := CMD_ABORTED;
                                                            _homingSubState := HOMING_IDLE;
                                                        // ELSE
                                                            //   ;// Wait for finish homing process
                                                        END_IF;

                                                    HOMING_POSITION:
                                                        tempStateChangeActive := FALSE;
                                                        CASE _activeHomingState OF
                                                            HOMING_ON_FIXED_STOP:
                                                                // Execute moving to homeposition
                                                                _instMoveAbsolute(Axis := _refPosAxis^,
                                                                                Execute := TRUE,
                                                                                Position := _homingPosition,
                                                                                Direction := SHORTEST_WAY_DIR);

                                                                // Evaluate MC_Command
                                                                IF (_instMoveAbsolute.Done = TRUE) THEN
                                                                    // Homeposition reached - Set next state
                                                                    _exeOfBasicMotion := CMD_DONE;
                                                                    _homingSubState := HOMING_IDLE;

                                                                ELSIF (_instMoveAbsolute.Error = TRUE) THEN
                                                                    // Errorhandling
                                                                    _status := AxisStatus#ERR_MC_MOVEABSOLUTE;
                                                                    _statusText := STRING#'ERR_MC_MOVEABSOLUTE';
                                                                    _errorAutoCleared := TRUE;
                                                                    _diagnostics.subfunctionStatus := _instMoveAbsolute.ErrorId;
                                                                    _subfunctionStatus := _instMoveAbsolute.ErrorId;
                                                                    // Set next state
                                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                                    _basicMotionState := CMD_BUSY;
                                                                    _activeHomingState := STANDARD_HOMING;
                                                                    _exeOfBasicMotion := CMD_ERROR;
                                                                    _homingSubState := HOMING_IDLE;

                                                                ELSIF (_instMoveAbsolute.CommandAborted = TRUE) THEN
                                                                    // Set next state
                                                                    _exeOfBasicMotion := CMD_ABORTED;
                                                                    _homingSubState := HOMING_IDLE;
                                                                // ELSE
                                                                    //   ; // Wait for reaching homeposition
                                                                END_IF;

                                                            HOMING_ON_FIXED_STOP_WITH_MOVING_OUT_OF_CLAMPING:
                                                                // Execute moving to homeposition
                                                                IF (_refPosAxis <> NULL) THEN // Axis type is TO_PositioningAxis or TO_SynchronousAxis
                                                                    tempLReal := _refPosAxis^.Clamping.PositionTolerance;
                                                                ELSE // Invalid TO specification
                                                                    tempLReal := 0.0;
                                                                END_IF;

                                                                CASE _direction OF
                                                                    FORWARD_DIR:
                                                                        _homingPosition := _homingPosition - (DISTANCE_SCALING * tempLReal);

                                                                    BACKWARD_DIR:
                                                                        _homingPosition := _homingPosition + (DISTANCE_SCALING * tempLReal);
                                                                END_CASE;

                                                                // Execute moving to homeposition
                                                                _instMoveAbsolute(Axis := _refPosAxis^,
                                                                                Execute := TRUE,
                                                                                Position := _homingPosition,
                                                                                Direction := SHORTEST_WAY_DIR);

                                                                // Evaluate MC_Command
                                                                IF (_instMoveAbsolute.Done = TRUE) AND (_instTorqueLimiting.InClamping = FALSE) THEN
                                                                    // Homeposition reached - Set next state
                                                                    _exeOfBasicMotion := CMD_DONE;
                                                                    _homingSubState := HOMING_IDLE;

                                                                ELSIF (_instMoveAbsolute.Error = TRUE) THEN
                                                                    // Errorhandling
                                                                    _status := AxisStatus#ERR_MC_MOVEABSOLUTE;
                                                                    _statusText := STRING#'ERR_MC_MOVEABSOLUTE';
                                                                    _errorAutoCleared := TRUE;
                                                                    _diagnostics.subfunctionStatus := _instMoveAbsolute.ErrorId;
                                                                    _subfunctionStatus := _instMoveAbsolute.ErrorId;
                                                                    // Set next state
                                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                                    _basicMotionState := CMD_BUSY;
                                                                    _activeHomingState := STANDARD_HOMING;
                                                                    _exeOfBasicMotion := CMD_ERROR;
                                                                    _homingSubState := HOMING_IDLE;

                                                                ELSIF (_instMoveAbsolute.CommandAborted = TRUE) THEN
                                                                    // Set next state
                                                                    _exeOfBasicMotion := CMD_ABORTED;
                                                                    _homingSubState := HOMING_IDLE;

                                                                // ELSE
                                                                    //   ; // Wait for reaching homeposition
                                                                END_IF;

                                                            HOMING_ON_FIXED_STOP_WITH_MOVING_TO_TARGET_POSITION:
                                                                // Execute moving to target position
                                                                _instMoveAbsolute(Axis := _refPosAxis^,
                                                                                Execute := TRUE,
                                                                                Position := config.homing.extendedModeTargetPosition);

                                                                // Evaluate MC_Command
                                                                IF (_instMoveAbsolute.Done = TRUE) AND (_instTorqueLimiting.InClamping = FALSE) THEN
                                                                    // Homeposition reached - Set next state
                                                                    _exeOfBasicMotion := CMD_DONE;
                                                                    _homingSubState := HOMING_IDLE;

                                                                ELSIF (_instMoveAbsolute.Error = TRUE) THEN
                                                                    // Errorhandling
                                                                    _status := AxisStatus#ERR_MC_MOVEABSOLUTE;
                                                                    _statusText := STRING#'ERR_MC_MOVEABSOLUTE';
                                                                    _errorAutoCleared := TRUE;
                                                                    _diagnostics.subfunctionStatus := _instMoveAbsolute.ErrorId;
                                                                    _subfunctionStatus := _instMoveAbsolute.ErrorId;
                                                                    // Set next state
                                                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                                                    _basicMotionState := CMD_BUSY;
                                                                    _activeHomingState := STANDARD_HOMING;
                                                                    _exeOfBasicMotion := CMD_ERROR;
                                                                    _homingSubState := HOMING_IDLE;

                                                                ELSIF (_instMoveAbsolute.CommandAborted = TRUE) THEN
                                                                    // Set next state
                                                                    _exeOfBasicMotion := CMD_ABORTED;
                                                                    _homingSubState := HOMING_IDLE;

                                                                // ELSE
                                                                    //   ; // Wait for reaching homeposition
                                                                END_IF;
                                                        END_CASE;
                                                ELSE
                                                    // Errorhandling
                                                    _status := AxisStatus#ERR_UNDEFINED_EXTENDED_HOMING_SUBSTATE;
                                                    _statusText := STRING#'ERR_UNDEFINED_EXTENDED_HOMING_SUBSTATE';
                                                    _errorUserCleared := TRUE;
                                                    _diagnostics.subfunctionStatus := WORD#0000;
                                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                                    // Set errorstate
                                                    _state := FB_ERROR;
                                                    tempStateChangeActive := FALSE;
                                                END_CASE;

                                            UNTIL (tempStateChangeActive = FALSE) // Repeat execution if a state is changing
                                            END_REPEAT;

                                        CMD_DONE,
                                        CMD_ABORTED,
                                        CMD_ERROR:
                                            // Return to NO_SELECTION if command finished
                                            IF (_basicCommand.%X10 = FALSE) // homing = FALSE
                                            THEN
                                                // Return to NO_HOMING_ACTIVE if command finished
                                                _basicMotionState := NO_SELECTION;
                                                _activeHomingState := STANDARD_HOMING;
                                                _exeOfBasicMotion := CMD_BUSY;
                                                _homingSubState := HOMING_IDLE;
                                            END_IF;
                                        ELSE
                                            // Errorhandling
                                            _status := AxisStatus#ERR_UNDEFINED_EXTENDED_HOMING_STATE;
                                            _statusText := STRING#'ERR_UNDEFINED_EXTENDED_HOMING_STATE';
                                            _errorUserCleared := TRUE;
                                            _diagnostics.subfunctionStatus := WORD#0000;
                                            _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                            // Set errorstate
                                            _state := FB_ERROR;
                                    END_CASE;

                            ELSE
                                // Errorhandling
                                _status := AxisStatus#ERR_INVALID_HOMING_EXTENDED_MODE;
                                _statusText := STRING#'ERR_INVALID_HOMING_EXTENDED_MODE';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := WORD#0000;
                                _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                                _activeHomingState := STANDARD_HOMING;
                                _basicMotionState := NO_SELECTION;
                            END_CASE;

                        GEAR_IN_RELATIVE_SELECTED:
                            // Additional features (applicative): Change setpoint on the fly (gear ratio)

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset GEAR_IN command
                                _instGearIn(Master := _refMasterAxis^,
                                            Slave := _refSyncAxis^,
                                            Execute := FALSE);

                                _instGearIn.RatioNumerator := config.gearInRelative.ratioNumerator;
                                _ratioNumerator := config.gearInRelative.ratioNumerator;
                                _instGearIn.RatioDenominator := config.gearInRelative.ratioDenominator;
                                _ratioDenominator := config.gearInRelative.ratioDenominator;
                                _instGearIn.Acceleration := config.gearInRelative.acceleration;
                                _basicAcceleration := config.gearInRelative.acceleration;
                                _instGearIn.Deceleration := config.gearInRelative.deceleration;
                                _basicDeceleration := config.gearInRelative.deceleration;
                                _instGearIn.Jerk := config.gearInRelative.jerk;
                                _basicJerk := config.gearInRelative.jerk;
                                _ratioChangeOnTheFly := config.gearInRelative.ratioChangeOnTheFly;

                            ELSIF ((_ratioChangeOnTheFly = TRUE) // Flying change of ratio numerator
                                AND ((config.gearInRelative.ratioNumerator <> _ratioNumerator)
                                OR (config.gearInRelative.ratioDenominator <> _ratioDenominator)))
                                AND
                                (_instGearIn.CommandAborted = FALSE)
                            THEN
                                _instGearIn(Master := _refMasterAxis^,
                                            Slave := _refSyncAxis^,
                                            Execute := FALSE);

                                _instGearIn.RatioNumerator := config.gearInRelative.ratioNumerator;
                                _ratioNumerator := config.gearInRelative.ratioNumerator;   // Apply the new gear ratio numerator
                                _instGearIn.RatioDenominator := config.gearInRelative.ratioDenominator;
                                _ratioDenominator := config.gearInRelative.ratioDenominator; // Apply the new gear ratio denominator

                                // Copy also dynamics
                                _instGearIn.Acceleration := config.gearInRelative.acceleration;
                                _basicAcceleration := config.gearInRelative.acceleration;
                                _instGearIn.Deceleration := config.gearInRelative.deceleration;
                                _basicDeceleration := config.gearInRelative.deceleration;
                                _instGearIn.Jerk := config.gearInRelative.jerk;
                                _basicJerk := config.gearInRelative.jerk;
                            END_IF;

                            // Call MC_Command
                            _instGearIn(Master := _refMasterAxis^,
                                        Slave := _refSyncAxis^,
                                        Execute := _basicCommand.%X7 OR _firstCycleBasicMotion); // Input: gearInRelative

                            // Evaluate MC_Command
                            IF (_instGearIn.Busy = FALSE) AND
                                (_instGearIn.Error = FALSE) AND
                                (_instGearIn.CommandAborted = FALSE) AND
                                (_instGearIn.InGear = FALSE)
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instGearIn.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_GEARIN;
                                _statusText := STRING#'ERR_MC_GEARIN';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instGearIn.ErrorId;
                                _subfunctionStatus := _instGearIn.ErrorId;
                                _ratioChangeOnTheFly := FALSE;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                                //   ; // Command selected
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instGearIn.Busy;
                            _exeOfBasicMotion.%X2 := _instGearIn.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instGearIn.Error;
                            //#statExeOfBasicMotion.%X6 := tempStatusWord.%X21 AND NOT instGearIn.InGear; // write Synchronizing only when bit of instance of MC_GearIn.InGear = FALSE
                            _exeOfBasicMotion.%X7 := _instGearIn.InGear;

                        GEAR_IN_ABSOLUTE_SELECTED:
                            // Additional features (applicative): Change setpoint on the fly (gear ratio)

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset GEAR_IN_POS command
                                _instGearInPos(Master := _refMasterAxis^,
                                               Slave := _refSyncAxis^,
                                               Execute := FALSE);

                                _instGearInPos.RatioNumerator := config.gearInAbsolute.ratioNumerator;
                                _ratioNumerator := config.gearInAbsolute.ratioNumerator;
                                _instGearInPos.RatioDenominator := config.gearInAbsolute.ratioDenominator;
                                _ratioDenominator := config.gearInAbsolute.ratioDenominator;

                                _instGearInPos.MasterSyncPosition := config.gearInAbsolute.masterSyncPosition;
                                _instGearInPos.SlaveSyncPosition := config.gearInAbsolute.slaveSyncPosition;
                                _instGearInPos.SyncProfileReference := config.gearInAbsolute.syncProfileReference;
                                _instGearInPos.MasterStartDistance := config.gearInAbsolute.masterStartDistance;
                                _instGearInPos.Velocity := config.gearInAbsolute.velocity;
                                _instGearInPos.Acceleration := config.gearInAbsolute.acceleration;
                                _instGearInPos.Deceleration := config.gearInAbsolute.deceleration;
                                _instGearInPos.Jerk := config.gearInAbsolute.jerk;
                                _instGearInPos.SyncDirection := config.gearInAbsolute.syncDirection;

                                _ratioChangeOnTheFly := config.gearInAbsolute.ratioChangeOnTheFly;

                            ELSIF (((_ratioChangeOnTheFly = TRUE) AND (config.gearInAbsolute.ratioNumerator <> _ratioNumerator))
                                OR ((_ratioChangeOnTheFly = TRUE) AND (config.gearInAbsolute.ratioDenominator <> _ratioDenominator)))
                                AND
                                (_instGearInPos.CommandAborted = FALSE)
                            THEN
                                _instGearInPos(Master := _refMasterAxis^,
                                            Slave := _refSyncAxis^,
                                            Execute := FALSE);

                                _instGearInPos.RatioNumerator := config.gearInAbsolute.ratioNumerator;
                                _ratioNumerator := config.gearInAbsolute.ratioNumerator;
                                _instGearInPos.RatioDenominator := config.gearInAbsolute.ratioDenominator;
                                _ratioDenominator := config.gearInAbsolute.ratioDenominator;

                                // Copy also dynamics
                                _instGearInPos.MasterSyncPosition := config.gearInAbsolute.masterSyncPosition;
                                _instGearInPos.SlaveSyncPosition := config.gearInAbsolute.slaveSyncPosition;
                                _instGearInPos.SyncProfileReference := config.gearInAbsolute.syncProfileReference;
                                _instGearInPos.MasterStartDistance := config.gearInAbsolute.masterStartDistance;
                                _instGearInPos.Velocity := config.gearInAbsolute.velocity;
                                _instGearInPos.Acceleration := config.gearInAbsolute.acceleration;
                                _instGearInPos.Deceleration := config.gearInAbsolute.deceleration;
                                _instGearInPos.Jerk := config.gearInAbsolute.jerk;
                                _instGearInPos.SyncDirection := config.gearInAbsolute.syncDirection;
                            END_IF;

                            // Call MC_Command
                            _instGearInPos(Master := _refMasterAxis^,
                                           Slave := _refSyncAxis^,
                                           Execute := _basicCommand.%X8 OR _firstCycleBasicMotion); // Input: gearInAbsolute

                            // Evaluate MC_Command
                            IF (_instGearInPos.Busy = FALSE) AND
                                (_instGearInPos.Error = FALSE) AND
                                (_instGearInPos.CommandAborted = FALSE) AND
                                (_instGearInPos.StartSync = FALSE) AND
                                (_instGearInPos.InSync = FALSE)
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instGearInPos.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_GEARINPOS;
                                _statusText := STRING#'ERR_MC_GEARINPOS';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instGearInPos.ErrorId;
                                _subfunctionStatus := _instGearInPos.ErrorId;
                                _ratioChangeOnTheFly := FALSE;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                                //   ; // Command selected
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instGearInPos.Busy;
                            _exeOfBasicMotion.%X2 := _instGearInPos.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instGearInPos.Error;
                            _exeOfBasicMotion.%X6 := _instGearInPos.StartSync;
                            _exeOfBasicMotion.%X7 := _instGearInPos.InSync;

                        GEAR_IN_VELOCITY_SELECTED:

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset GEAR_IN_VELOCITY command
                                _instGearInVelocity(Master := _refMasterAxis^,
                                                    Slave := _refSyncAxis^,
                                                    Execute := FALSE,
                                                    Acceleration := config.gearInVelocity.acceleration,
                                                    Deceleration := config.gearInVelocity.deceleration,
                                                    Jerk := config.gearInVelocity.jerk,
                                                    PositionControlled := config.gearInVelocity.positionControlled);
                            END_IF;

                            // Call MC_Command
                            _instGearInVelocity(Master := _refMasterAxis^,
                                                Slave := _refSyncAxis^,
                                                Execute := _basicCommand.%X12 OR _firstCycleBasicMotion, // Input: gearInVelocity
                                                ContinuousUpdate := config.gearInVelocity.continuousUpdate,
                                                RatioNumerator := config.gearInVelocity.ratioNumerator,
                                                RatioDenominator := config.gearInVelocity.ratioDenominator);

                            // Evaluate MC_Command
                            IF (_instGearInVelocity.Busy = FALSE) AND
                                (_instGearInVelocity.Error = FALSE) AND
                                (_instGearInVelocity.CommandAborted = FALSE) AND
                                (_instGearInVelocity.StartSync = FALSE) AND
                                (_instGearInVelocity.InSync = FALSE)
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instGearInVelocity.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_GEARINVELOCITY;
                                _statusText := STRING#'ERR_MC_GEARINVELOCITY';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instGearInVelocity.ErrorId;
                                _subfunctionStatus := _instGearInVelocity.ErrorId;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                            //   ; // Command selected
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instGearInVelocity.Busy;
                            _exeOfBasicMotion.%X2 := _instGearInVelocity.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instGearInVelocity.Error;
                            _exeOfBasicMotion.%X6 := _instGearInVelocity.StartSync;
                            _exeOfBasicMotion.%X7 := _instGearInVelocity.InSync;

                        CAM_IN_SELECTED:

                            // Firstcycle of command
                            IF (_firstCycleBasicMotion = TRUE) THEN
                                // Reset CAM_IN command
                                _instCamIn(Master := _refMasterAxis^,
                                           Slave := _refSyncAxis^,
                                           Cam := _refCamBase^,
                                           Execute := FALSE,
                                           MasterOffset := config.camIn.masterOffset,
                                           SlaveOffset := config.camIn.slaveOffset,
                                           MasterScaling := config.camIn.masterScaling,
                                           SlaveScaling := config.camIn.slaveScaling,
                                           MasterSyncPosition := config.camIn.masterSyncPosition,
                                           SyncProfileReference := config.camIn.syncProfileReference,
                                           MasterStartDistance := config.camIn.masterStartDistance,
                                           Velocity := config.camIn.velocity,
                                           Acceleration := config.camIn.acceleration,
                                           Deceleration := config.camIn.deceleration,
                                           Jerk := config.camIn.jerk,
                                           ApplicationMode := config.camIn.applicationMode,
                                           SyncDirection := config.camIn.syncDirection);

                                _applicationMode := config.camIn.applicationMode;
                            END_IF;

                            // Call MC_Command
                            _instCamIn(Master := _refMasterAxis^,
                                       Slave := _refSyncAxis^,
                                       Cam := _refCamBase^,
                                       Execute := _basicCommand.%X9 OR _firstCycleBasicMotion); // Input: camIn

                            // Evaluate MC_Command
                            IF ((_instCamIn.Busy = FALSE) AND
                                (_instCamIn.Error = FALSE) AND
                                (_instCamIn.CommandAborted = FALSE) AND
                                (_instCamIn.InSync = FALSE) AND
                                (_instCamIn.StartSync = FALSE) AND
                                (_basicCommand.%X9 = FALSE))
                                AND // Wait for one cycle EndOfProfile (--> Done) before function is finished at applicationMode ONCE
                                ((_applicationMode <> APPLICATION_MODE_ONCE) OR
                                ((_applicationMode = APPLICATION_MODE_ONCE) AND (_instCamIn.EndOfProfile = FALSE)))
                            THEN
                                // Return to NO_SELECTION if command finished
                                _basicMotionState := NO_SELECTION;

                            ELSIF (_instCamIn.Error = TRUE) THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_CAMIN;
                                _statusText := STRING#'ERR_MC_CAMIN';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instCamIn.ErrorId;
                                _subfunctionStatus := _instCamIn.ErrorId;
                                _diagnostics.basicMotionState := _basicMotionState;
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                            //   ; // Command selected
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instCamIn.Busy;
                            IF (_applicationMode = APPLICATION_MODE_ONCE) THEN
                                _exeOfBasicMotion.%X1 := _instCamIn.EndOfProfile;
                            END_IF;
                            _exeOfBasicMotion.%X2 := _instCamIn.CommandAborted;
                            _exeOfBasicMotion.%X3 := _instCamIn.Error;
                            _exeOfBasicMotion.%X6 := _instCamIn.StartSync;
                            _exeOfBasicMotion.%X7 := _instCamIn.InSync;
                            _exeOfBasicMotion.%X8 := _instCamIn.EndOfProfile;

                        GEAR_OUT_CAM_OUT_SELECTED:

                        // Firstcycle of command
                        IF (_firstCycleBasicMotion = TRUE) THEN
                            _applicativeBasicMotionError := FALSE;
                            _firstCycleBasicMotion := FALSE;

                            // Reset CAM_OUT command
                            _instCamOut(Slave := _refSyncAxis^,
                                        Execute := FALSE,
                                        SlavePosition := config.gearOutCamOut.slavePosition,
                                        SyncProfileReference := config.gearOutCamOut.syncProfileReference,
                                        MasterStopDistance := config.gearOutCamOut.masterStopDistance,
                                        Deceleration := config.gearOutCamOut.deceleration,
                                        Jerk := config.gearOutCamOut.jerk,
                                        SyncOutDirection := config.gearOutCamOut.syncOutDirection);

                            // Reset GEAR_OUT command
                            _instGearOut(Slave := _refSyncAxis^,
                                         Execute := FALSE,
                                         SlavePosition := config.gearOutCamOut.slavePosition,
                                         SyncProfileReference := config.gearOutCamOut.syncProfileReference,
                                         MasterStopDistance := config.gearOutCamOut.masterStopDistance,
                                         Deceleration := config.gearOutCamOut.deceleration,
                                         Jerk := config.gearOutCamOut.jerk,
                                         SyncOutDirection := config.gearOutCamOut.syncOutDirection);

                            CASE config.gearOutCamOut.gearOutCamOutMode OF
                                SYNCOUT_MODE_AUTOMATIC,
                                SYNCOUT_MODE_GEAROUT,
                                SYNCOUT_MODE_CAMOUT:
                                    // Get axis waiting function state
                                    IF (_typeAxis = SYNC_AXIS) THEN
                                        IF (_waitingFunctionStateAbortAutomatic < 0) // < 0: Automatic abort of waiting sync commands disabled
                                        THEN
                                            // Read waiting function state of axis
                                            _waitingFunctionState := _refSyncAxis^.StatusSynchronizedMotion.WaitingFunctionState;
                                        ELSE
                                            // Waiting function state already read out
                                            _waitingFunctionState := _waitingFunctionStateAbortAutomatic;
                                        END_IF;
                                        // Read function state of axis
                                        _functionState := _refSyncAxis^.StatusSynchronizedMotion.FunctionState;
                                    END_IF;

                                    _gearAndCamOutMode := config.gearOutCamOut.gearOutCamOutMode;
                                    _syncOutState := SYNCOUT_STATE_CHECK_WAITING; // Set next state

                                ELSE
                                    // Errorhandling - Invalid mode
                                    _status := AxisStatus#ERR_INVALID_GEAROUT_CAMOUT_MODE;
                                    _statusText := STRING#'ERR_INVALID_GEAROUT_CAMOUT_MODE';
                                    _errorAutoCleared := TRUE;
                                    _diagnostics.subfunctionStatus := WORD#0000;
                                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                                    _applicativeBasicMotionError := TRUE;
                                    // Set next state
                                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                                    _basicMotionState := NO_SELECTION;
                            END_CASE;
                        END_IF;

                        IF (_applicativeBasicMotionError = FALSE) THEN
                            CASE _syncOutState OF
                                // ===========================================================
                                SYNCOUT_STATE_CHECK_WAITING:

                                    CASE _gearAndCamOutMode OF
                                        SYNCOUT_MODE_GEAROUT:
                                            CASE _waitingFunctionStateAbortAutomatic OF
                                                WFS_FS_CAMIN:
                                                    // Abort waiting camming in advance
                                                    _instCamOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                    _syncOutState := SYNCOUT_STATE_CAMOUT_WAITING_BUSY; // Set next state

                                                WFS_FS_GEARINPOS:
                                                    CASE config.gearOutCamOut.syncProfileReference OF
                                                        CANCEL_ONLY_WAITING_GEARING_CAMMING:
                                                            // Only gearOut - Set next state
                                                            _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE;
                                                    ELSE
                                                        CASE _functionState OF
                                                            WFS_FS_GEARIN,
                                                            WFS_FS_GEARINPOS:
                                                                // Active gearing function
                                                                _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE; // Set next state
                                                        ELSE
                                                            // Abort waiting gearing in advance
                                                            _instGearOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                            _syncOutState := SYNCOUT_STATE_GEAROUT_WAITING_BUSY; // Set next state
                                                        END_CASE;
                                                    END_CASE;

                                            ELSE
                                                // Only gearOut - Set next state
                                                _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE;
                                            END_CASE;

                                        SYNCOUT_MODE_CAMOUT:
                                            CASE _waitingFunctionStateAbortAutomatic OF
                                                WFS_FS_GEARINPOS: // Waiting
                                                    // Abort waiting gearing in advance
                                                    _instGearOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                    _syncOutState := SYNCOUT_STATE_GEAROUT_WAITING_BUSY; // Set next state

                                                WFS_FS_CAMIN: // Waiting
                                                    CASE config.gearOutCamOut.syncProfileReference OF
                                                        CANCEL_ONLY_WAITING_GEARING_CAMMING:
                                                            // Only gearOut - Set next state
                                                            _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE;
                                                    ELSE
                                                        CASE _functionState OF
                                                            WFS_FS_CAMIN: // Active
                                                                _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE; // Set next state
                                                        ELSE
                                                            // Abort waiting camming in advance
                                                            _instCamOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                            _syncOutState := SYNCOUT_STATE_CAMOUT_WAITING_BUSY; // Set next state
                                                        END_CASE;
                                                    END_CASE;
                                            ELSE
                                                // Only camOut - Set next state
                                                _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE;
                                            END_CASE;

                                        SYNCOUT_MODE_AUTOMATIC:
                                            CASE _waitingFunctionState OF
                                                WFS_FS_GEARINPOS, // Waiting
                                                WFS_FS_GEAROUT: // Waiting
                                                    CASE _functionState OF
                                                        WFS_FS_GEARIN, // Active
                                                        WFS_FS_GEARINPOS: // Active
                                                            ; // Gearing active - Waiting gearInPos will be aborted with MC_GEAROUT

                                                        WFS_FS_GEAROUT:
                                                            IF (_waitingFunctionStateAbortAutomatic < 0) THEN
                                                                ; // Automatic abort of waiting sync commands disabled
                                                            ELSE
                                                                // Automatic abort of waiting sync commands enabled - Separate call of MC_GearOut instruction is required
                                                                _instGearOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                            END_IF;
                                                    ELSE
                                                        _instGearOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                    END_CASE;
                                                    _functionState := -1;// Function state has to be updated at next use
                                                    _syncOutState := SYNCOUT_STATE_GEAROUT_WAITING_BUSY; // Set next state

                                                WFS_FS_CAMIN,  // Waiting
                                                WFS_FS_CAMOUT:  // Waiting
                                                    CASE _functionState OF
                                                        WFS_FS_CAMIN: // Active
                                                            ; // CamIn Active - Waiting CamIn will be aborted with MC_CAMOUT

                                                        WFS_FS_CAMOUT: // Active
                                                            IF (_waitingFunctionStateAbortAutomatic < 0) THEN
                                                                ; // Automatic abort of waiting sync commands disabled
                                                            ELSE
                                                                // Automatic abort of waiting sync commands enabled - Separate call of MC_CamOut instruction is required
                                                                _instCamOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                            END_IF;
                                                    ELSE
                                                        _instCamOut.SyncProfileReference := CANCEL_ONLY_WAITING_GEARING_CAMMING;
                                                    END_CASE;
                                                    _functionState := -1;// Function state has to be updated at next use
                                                    _syncOutState := SYNCOUT_STATE_CAMOUT_WAITING_BUSY; // Set next state

                                        ELSE
                                            // No waiting synchronous operation
                                            _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE; // Set next state
                                        END_CASE;
                                    END_CASE;
                                    tempStateChangeActive := TRUE;

                                // ===========================================================
                                SYNCOUT_STATE_CHECK_ACTIVE:

                                    _instGearOut.SyncProfileReference := config.gearOutCamOut.syncProfileReference;
                                    _instCamOut.SyncProfileReference := config.gearOutCamOut.syncProfileReference;

                                    CASE _gearAndCamOutMode OF
                                        SYNCOUT_MODE_GEAROUT:
                                            _syncOutState := SYNCOUT_STATE_GEAROUT_ACTIVE_BUSY; // Set next state

                                        SYNCOUT_MODE_CAMOUT:
                                            _syncOutState := SYNCOUT_STATE_CAMOUT_ACTIVE_BUSY; // Set next state

                                        SYNCOUT_MODE_AUTOMATIC:
                                            CASE config.gearOutCamOut.syncProfileReference OF
                                                CANCEL_ONLY_WAITING_GEARING_CAMMING:
                                                    // No active synchronous operation
                                                    _syncOutState := SYNCOUT_STATE_DONE; // Set next state
                                            ELSE
                                                // Update function state of axis
                                                IF (_typeAxis = SYNC_AXIS) THEN
                                                    IF (_functionState < 0) THEN
                                                        _functionState := _refSyncAxis^.StatusSynchronizedMotion.FunctionState;
                                                    END_IF;
                                                END_IF;

                                                CASE _functionState OF
                                                    WFS_FS_GEAROUT,   // Active - Leads to error of MC_Instruction
                                                    WFS_FS_GEARIN,    // Active
                                                    WFS_FS_GEARINPOS: // Active
                                                        // Active gearing function
                                                        _syncOutState := SYNCOUT_STATE_GEAROUT_ACTIVE_BUSY; // Set next state

                                                    WFS_FS_CAMOUT, // Active - Leads to error of MC_Instruction
                                                    WFS_FS_CAMIN:  // Active
                                                        // Active camming function
                                                        _syncOutState := SYNCOUT_STATE_CAMOUT_ACTIVE_BUSY; // Set next state

                                                ELSE
                                                    // No active synchronous operation
                                                    _syncOutState := SYNCOUT_STATE_DONE; // Set next state
                                                END_CASE;
                                            END_CASE;

                                    END_CASE;
                                    tempStateChangeActive := TRUE;

                                // ===========================================================
                                SYNCOUT_STATE_GEAROUT_WAITING_BUSY,
                                SYNCOUT_STATE_GEAROUT_ACTIVE_BUSY:

                                    // Call MC_Instruction
                                    _instGearOut(Slave := _refSyncAxis^,
                                                Execute := TRUE);

                                    IF _instGearOut.Done THEN
                                        CASE _syncOutState OF
                                            SYNCOUT_STATE_GEAROUT_WAITING_BUSY:
                                            // Set next state
                                            _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE;
                                            tempStateChangeActive := TRUE;

                                            SYNCOUT_STATE_GEAROUT_ACTIVE_BUSY:
                                            _syncOutState := SYNCOUT_STATE_DONE; // Set next state

                                        END_CASE;
                                        // Reset MC_Instruction
                                        _instGearOut(Slave := _refSyncAxis^,
                                                    Execute := FALSE);

                                    ELSIF _instGearOut.CommandAborted THEN
                                        _syncOutState := SYNCOUT_STATE_ABORTED; // Set next state
                                    END_IF;

                                // ===========================================================
                                SYNCOUT_STATE_CAMOUT_WAITING_BUSY,
                                SYNCOUT_STATE_CAMOUT_ACTIVE_BUSY:

                                    // Call MC_Instruction
                                    _instCamOut(Slave := _refSyncAxis^,
                                                Execute := TRUE);

                                    IF _instCamOut.Done THEN
                                        CASE _syncOutState OF
                                            SYNCOUT_STATE_CAMOUT_WAITING_BUSY:
                                                // Set next state
                                                _syncOutState := SYNCOUT_STATE_CHECK_ACTIVE;
                                                tempStateChangeActive := TRUE;

                                            SYNCOUT_STATE_CAMOUT_ACTIVE_BUSY:
                                                _syncOutState := SYNCOUT_STATE_DONE; // Set next state

                                        END_CASE;

                                        // Reset MC_Instruction
                                        _instCamOut(Slave := _refSyncAxis^,
                                                    Execute := FALSE);

                                    ELSIF _instCamOut.CommandAborted THEN
                                        _syncOutState := SYNCOUT_STATE_ABORTED; // Set next state
                                    END_IF;

                                // ===========================================================
                                SYNCOUT_STATE_DONE,
                                SYNCOUT_STATE_ABORTED,
                                SYNCOUT_STATE_ERROR:

                                    IF NOT _basicCommand.%X11 THEN
                                        // Return to NO_SELECTION if command finished
                                        _basicMotionState := NO_SELECTION;
                                    END_IF;

                            END_CASE;

                            IF _instGearOut.Error THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_GEAROUT;
                                _statusText := STRING#'ERR_MC_GEAROUT';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instGearOut.ErrorId;
                                _subfunctionStatus := _instGearOut.ErrorId;
                                _diagnostics.basicMotionState := _basicMotionState;
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;

                                _syncOutState := SYNCOUT_STATE_ERROR; // Set next state

                            ELSIF _instCamOut.Error THEN
                                // Errorhandling
                                _status := AxisStatus#ERR_MC_CAMOUT;
                                _statusText := STRING#'ERR_MC_CAMOUT';
                                _errorAutoCleared := TRUE;
                                _diagnostics.subfunctionStatus := _instCamOut.ErrorId;
                                _subfunctionStatus := _instCamOut.ErrorId;
                                _diagnostics.basicMotionState := _basicMotionState;
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _basicMotionState := NO_SELECTION;

                                _syncOutState := SYNCOUT_STATE_ERROR; // Set next state
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _syncOutState < SYNCOUT_STATE_DONE; // 7
                            _exeOfBasicMotion.%X1 := _syncOutState = SYNCOUT_STATE_DONE; // 7
                            _exeOfBasicMotion.%X2 := _syncOutState = SYNCOUT_STATE_ABORTED; // 8
                            _exeOfBasicMotion.%X3 := _syncOutState = SYNCOUT_STATE_ERROR; // 9
                            _exeOfBasicMotion.%X6 := _instCamOut.StartSyncOut OR _instGearOut.StartSyncOut;
                        END_IF;

                    ELSE
                        // Errorhandling
                        _status := AxisStatus#ERR_UNDEFINED_BASIC_MOTION_STATE;
                        _statusText := STRING#'ERR_UNDEFINED_BASIC_MOTION_STATE';
                        _errorUserCleared := TRUE;
                        _diagnostics.subfunctionStatus := WORD#0000;
                        _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                        // Set errorstate
                        _state := FB_ERROR;
                END_CASE;

                ABORT_WAITING_GEARINPOS_OR_CAMIN:
                    // Abort waiting absolute gearing / camIn job if new basic motion job is selected (config.generalSettings.abortWaitingSyncCmd = TRUE)

                    CASE _waitingFunctionStateAbortAutomatic OF
                        WFS_FS_GEARINPOS: // Waiting

                            _instGearOut(Slave := _refSyncAxis^,
                                         Execute := TRUE);

                            IF (_instGearOut.Done = TRUE) OR (_instGearOut.CommandAborted = TRUE)
                            THEN // Relative gearing command has aborted waiting absolute gearing job
                                _mainSelectionState := CALL_BASIC_MOTION; // Execute new basic motion command
                                tempStateChangeActive := TRUE;
                                _firstCycleBasicMotion := TRUE;

                            ELSIF (_instGearOut.Error = TRUE) THEN
                                _status := AxisStatus#ERR_MC_GEAROUT;
                                _statusText := STRING#'ERR_MC_GEAROUT';
                                _diagnostics.subfunctionStatus := _instGearOut.ErrorId;
                                _subfunctionStatus := _instGearOut.ErrorId;
                                // Errorhandling
                                _errorAutoCleared := TRUE;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _mainSelectionState := CALL_BASIC_MOTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                            //   ; // Command running
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instGearOut.Busy;

                        WFS_FS_CAMIN: // Waiting

                            _instCamOut(Slave := _refSyncAxis^,
                                        Execute := TRUE);

                            IF (_instCamOut.Done = TRUE) OR (_instCamOut.CommandAborted = TRUE)
                            THEN
                                _mainSelectionState := CALL_BASIC_MOTION; // Execute new basic motion command
                                tempStateChangeActive := TRUE;
                                _firstCycleBasicMotion := TRUE;

                            ELSIF (_instCamOut.Error = TRUE) THEN
                                _status := AxisStatus#ERR_MC_CAMOUT;
                                _statusText := STRING#'ERR_MC_CAMOUT';
                                _diagnostics.subfunctionStatus := _instCamOut.ErrorId;
                                _subfunctionStatus := _instCamOut.ErrorId;
                                // Errorhandling
                                _errorAutoCleared := TRUE;
                                // Set next state
                                _state := AXIS_STOP_ON_ERROR_SELECTION;
                                _mainSelectionState := CALL_BASIC_MOTION;
                                _basicMotionState := NO_SELECTION;
                            // ELSE
                            //   ; // Command running
                            END_IF;

                            // Write MC_Command outputs to internal variable
                            _exeOfBasicMotion := 16#0;
                            _exeOfBasicMotion.%X0 := _instCamOut.Busy;

                    END_CASE;
                ELSE
                    // Errorhandling
                    _status := AxisStatus#ERR_UNDEFINED_MAIN_SELECTION_STATE;
                    _statusText := STRING#'ERR_UNDEFINED_MAIN_SELECTION_STATE';
                    _errorUserCleared := TRUE;
                    _diagnostics.subfunctionStatus := WORD#0000;
                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                    // Set errorstate
                    _state := FB_ERROR;
            END_CASE;

        UNTIL (tempStateChangeActive = FALSE)
        END_REPEAT;

        //----------------------------------------------------------------------------------------------
        // Execution of homing functionality
        //----------------------------------------------------------------------------------------------

        // Statemachine for homing functionality
        CASE _passiveHomingState OF
            // Selection of extended homing mode
            NO_HOMING_ACTIVE:
                ; // Do nothing

            STANDARD_HOMING:
                // No additional features

                // Firstcycle of command
                IF (_firstCycleHoming = TRUE) THEN
                    // Reset MC_HOME command
                    _instHome(Axis := _refAxis^,
                            Execute := FALSE,
                            Position := config.homing.position,
                            Mode := config.homing.mode,
                            Sensor := config.homing.sensor);

                    IF (_basicMotionState = ACTIVE_HOMING_SELECTED) THEN
                        _basicMotionState := NO_SELECTION;
                    END_IF;
                END_IF;

                // Call MC_Command
                _instHome(Axis := _refAxis^,
                          Execute := _extendedCommand.%X2); // Input: homing

                // Evaluate MC_Command
                IF (_instHome.Busy = FALSE) AND
                    (_instHome.Done = FALSE) AND
                    (_instHome.CommandAborted = FALSE) AND
                    (_instHome.Error = FALSE)
                THEN
                    // Return to NO_SELECTION if command finished
                    _passiveHomingState := NO_HOMING_ACTIVE;

                ELSIF (_instHome.Error = TRUE) THEN
                    // Errorhandling
                    _status := AxisStatus#ERR_MC_HOME;
                    _statusText := STRING#'ERR_MC_HOME';
                    _errorAutoCleared := TRUE;
                    _diagnostics.subfunctionStatus := _instHome.ErrorId;
                    _subfunctionStatus := _instHome.ErrorId;
                    _passiveHomingState := NO_HOMING_ACTIVE;
                    // Set next state
                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                    // ELSE
                    //   ; // Command selected
                END_IF;
                _exeOfHoming := 16#0;
                _exeOfHoming.%X0 := _instHome.Busy;
                _exeOfHoming.%X1 := _instHome.Done;
                _exeOfHoming.%X2 := _instHome.CommandAborted;
                _exeOfHoming.%X3 := _instHome.Error;

            ELSE
                // Errorhandling
                _status := AxisStatus#ERR_INVALID_HOMING_EXTENDED_MODE;
                _statusText := STRING#'ERR_INVALID_HOMING_EXTENDED_MODE';
                _errorAutoCleared := TRUE;
                _diagnostics.subfunctionStatus := WORD#0000;
                _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                _diagnostics.basicMotionState := _basicMotionState;
                _diagnostics.superimposedMotionState := _supImpMotionState;
                // Set next state
                _state := AXIS_STOP_ON_ERROR_SELECTION;
                _basicMotionState := NO_SELECTION;
                _passiveHomingState := NO_HOMING_ACTIVE;
        END_CASE;

        //----------------------------------------------------------------------------------------------
        // Execution of functionalities of superimposed coordinate system
        //----------------------------------------------------------------------------------------------

        // Statemachine for superimposed motion commands
        // Write diagnostics
        _diagnostics.basicMotionState := _basicMotionState;
        _diagnostics.superimposedMotionState := _supImpMotionState;

        CASE _supImpMotionState OF
            NO_SELECTION:
                ; // Do nothing

            POS_SUPERIMPOSED_SELECTED:
                // Additional features (applicative) : Specified direction

                // Firstcycle of command
                IF (_firstCycleSupImpMotion = TRUE) THEN
                    // Configurate the direction of rotation
                    IF ((config.posSuperimposed.direction = 0) AND (config.posSuperimposed.distance >= 0.0))  // Sign of distance is evaluated
                        OR (config.posSuperimposed.direction = FORWARD_DIR)// Positive direction
                    THEN
                        _supImpMotionPosition := Abs(config.posSuperimposed.distance);
                        // Reset MC_MOVESUPERIMPOSED command
                        _instMoveSuperimposed(Axis := _refPosAxis^,
                                              Execute := FALSE,
                                              Distance := _supImpMotionPosition,
                                              VelocityDiff := config.posSuperimposed.velocityDiff,
                                              Acceleration := config.posSuperimposed.acceleration,
                                              Deceleration := config.posSuperimposed.deceleration,
                                              Jerk := config.posSuperimposed.jerk);

                        _applicativeSupImpMotionError := FALSE;

                    ELSIF ((config.posSuperimposed.direction = 0) AND (config.posSuperimposed.distance < 0.0)) // Sign of distance is evaluated
                        OR (config.posSuperimposed.direction = BACKWARD_DIR)// Negative direction
                    THEN
                        _supImpMotionPosition := -Abs(config.posSuperimposed.distance);
                        // Reset MC_MOVESUPERIMPOSED command
                        _instMoveSuperimposed(Axis := _refPosAxis^,
                                                Execute := FALSE,
                                                Distance := _supImpMotionPosition,
                                                VelocityDiff := config.posSuperimposed.velocityDiff,
                                                Acceleration := config.posSuperimposed.acceleration,
                                                Deceleration := config.posSuperimposed.deceleration,
                                                Jerk := config.posSuperimposed.jerk);

                        _applicativeSupImpMotionError := FALSE;

                    ELSE
                        // Errorhandling - Invalid direction
                        _status := AxisStatus#ERR_INVALID_POS_SUPERIMPOSED_DIR;
                        _statusText := STRING#'ERR_INVALID_POS_SUPERIMPOSED_DIR';
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := WORD#0000;
                        _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                        _applicativeSupImpMotionError := TRUE;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        _supImpMotionState := NO_SELECTION;
                    END_IF;
                END_IF;

                IF (_applicativeSupImpMotionError = FALSE) THEN
                    // Call MC_Command
                    _instMoveSuperimposed(Axis := _refPosAxis^,
                                          Execute := _supImpCommand.%X0); // Input: posSuperimposed

                    // Evaluate MC_Command
                    IF (_instMoveSuperimposed.Busy = FALSE) AND
                        (_instMoveSuperimposed.Error = FALSE) AND
                        (_instMoveSuperimposed.Done = FALSE) AND
                        (_instMoveSuperimposed.CommandAborted = FALSE)
                    THEN
                        // Return to NO_SELECTION if command finished
                        _supImpMotionState := NO_SELECTION;

                    ELSIF (_instMoveSuperimposed.Error = TRUE) THEN
                        // Errorhandling
                        _status := AxisStatus#ERR_MC_MOVESUPERIMPOSED;
                        _statusText := STRING#'ERR_MC_MOVESUPERIMPOSED';
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := _instMoveSuperimposed.ErrorId;
                        _subfunctionStatus := _instMoveSuperimposed.ErrorId;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        _supImpMotionState := NO_SELECTION;
                    // ELSE
                    //   ; // command selected
                    END_IF;
                    _exeOfSupImpMotionState := 16#0;
                    _exeOfSupImpMotionState.%X0 := _instMoveSuperimposed.Busy;
                    _exeOfSupImpMotionState.%X1 := _instMoveSuperimposed.Done;
                    _exeOfSupImpMotionState.%X2 := _instMoveSuperimposed.CommandAborted;
                    _exeOfSupImpMotionState.%X3 := _instMoveSuperimposed.Error;
                    _exeOfSupImpMotionState.%X4 := _instMoveSuperimposed.Busy;
                END_IF;

            HALT_SUPERIMPOSED_SELECTED:

                // Firstcycle of command
                IF (_firstCycleSupImpMotion = TRUE) THEN
                    _instHaltSuperimposed(Axis := _refPosAxis^,
                                          Execute := FALSE,
                                          Deceleration := config.haltSuperimposed.deceleration,
                                          Jerk := config.haltSuperimposed.jerk,
                                          AbortAcceleration := config.haltSuperimposed.abortAcceleration);
                END_IF;

                // Call MC_Command
                _instHaltSuperimposed(Axis := _refPosAxis^,
                                      Execute := _supImpCommand.%X3); // Input: haltSuperimposed

                // Evaluate MC_Command
                IF (_instHaltSuperimposed.Busy = FALSE) AND
                    (_instHaltSuperimposed.Error = FALSE) AND
                    (_instHaltSuperimposed.Done = FALSE) AND
                    (_instHaltSuperimposed.CommandAborted = FALSE)
                THEN
                    // Return to NO_SELECTION if command finished
                    _supImpMotionState := NO_SELECTION;

                ELSIF (_instHaltSuperimposed.Error = TRUE) THEN
                    // Errorhandling
                    _status := AxisStatus#ERR_MC_HALTSUPERIMPOSED;
                    _statusText := STRING#'ERR_MC_HALTSUPERIMPOSED';
                    _errorAutoCleared := TRUE;
                    _diagnostics.subfunctionStatus := _instHaltSuperimposed.ErrorId;
                    _subfunctionStatus := _instHaltSuperimposed.ErrorId;
                    // Set next state
                    _state := AXIS_STOP_ON_ERROR_SELECTION;
                    _supImpMotionState := NO_SELECTION;
                    // ELSE
                    //   ; // command selected
                END_IF;
                _exeOfSupImpMotionState := 16#0;
                _exeOfSupImpMotionState.%X0 := _instHaltSuperimposed.Busy;
                _exeOfSupImpMotionState.%X1 := _instHaltSuperimposed.Done;
                _exeOfSupImpMotionState.%X2 := _instHaltSuperimposed.CommandAborted;
                _exeOfSupImpMotionState.%X3 := _instHaltSuperimposed.Error;
                _exeOfSupImpMotionState.%X4 := _instHaltSuperimposed.Busy;

            PHASING_SELECTED:
                // Additional features (applicative) : Change setpoint on the fly (phaseShift)

                // Firstcycle of command
                IF (_firstCycleSupImpMotion = TRUE) THEN
                    // Reset MC_PHASING_ABSOLUTE command
                    _instPhasingAbsolute(Master := _refMasterAxis^,
                                         Slave := _refSyncAxis^,
                                         Execute := FALSE);

                    // Reset MC_PHASING_RELATIVE command
                    _instPhasingRelative(Master := _refMasterAxis^,
                                         Slave := _refSyncAxis^,
                                         Execute := FALSE);

                    _instPhasingAbsolute.PhaseShift := config.phasing.phaseShift;
                    _instPhasingRelative.PhaseShift := config.phasing.phaseShift;
                    _phaseShift := config.phasing.phaseShift;

                    _instPhasingAbsolute.Velocity := config.phasing.velocity;
                    _instPhasingRelative.Velocity := config.phasing.velocity;
                    _instPhasingAbsolute.Acceleration := config.phasing.acceleration;
                    _instPhasingRelative.Acceleration := config.phasing.acceleration;
                    _instPhasingAbsolute.Deceleration := config.phasing.deceleration;
                    _instPhasingRelative.Deceleration := config.phasing.deceleration;
                    _instPhasingAbsolute.Jerk := config.phasing.jerk;
                    _instPhasingRelative.Jerk := config.phasing.jerk;
                    _instPhasingAbsolute.ProfileReference := config.phasing.profileReference;
                    _instPhasingRelative.ProfileReference := config.phasing.profileReference;
                    _instPhasingAbsolute.PhasingDistance := config.phasing.phasingDistance;
                    _instPhasingRelative.PhasingDistance := config.phasing.phasingDistance;
                    _instPhasingAbsolute.StartPosition := config.phasing.startPosition;
                    _instPhasingRelative.StartPosition := config.phasing.startPosition;
                    _instPhasingAbsolute.Direction := config.phasing.direction;
                    _instPhasingRelative.Direction := config.phasing.direction;

                    _phaseAbsolute := config.phasing.phaseAbsolute;
                    _changePhaseShiftOnTheFly := config.phasing.phaseShiftChangeOnTheFly;

                ELSIF ((_changePhaseShiftOnTheFly = TRUE) AND
                    (config.phasing.phaseShift <> _phaseShift))
                    AND (_phaseAbsolute = TRUE)
                    AND (_instPhasingAbsolute.CommandAborted = FALSE)
                THEN
                    // Reset MC_PHASING_ABSOLUTE command - Phaseshift on the fly is only possible at phasing absolute
                    _instPhasingAbsolute(Master := _refMasterAxis^,
                                         Slave := _refSyncAxis^,
                                         Execute := FALSE);

                    _instPhasingAbsolute.PhaseShift := config.phasing.phaseShift;
                    _phaseShift := config.phasing.phaseShift;

                    // Copy also Dynamics
                    _instPhasingAbsolute.Velocity := config.phasing.velocity;
                    _instPhasingAbsolute.Acceleration := config.phasing.acceleration;
                    _instPhasingAbsolute.Deceleration := config.phasing.deceleration;
                    _instPhasingAbsolute.Jerk := config.phasing.jerk;
                    _instPhasingAbsolute.ProfileReference := config.phasing.profileReference;
                    _instPhasingAbsolute.PhasingDistance := config.phasing.phasingDistance;
                    _instPhasingAbsolute.StartPosition := config.phasing.startPosition;
                    _instPhasingAbsolute.Direction := config.phasing.direction;
                END_IF;

                // Select phasing absolute or relative
                IF (_phaseAbsolute = TRUE) THEN
                    // Absolute phasing
                    // Call MC_Command
                    _instPhasingAbsolute(Master := _refMasterAxis^,
                                         Slave := _refSyncAxis^,
                                         Execute := _supImpCommand.%X1); // Input: phasing
                    // Evaluate MC_Command
                    IF (_instPhasingAbsolute.Busy = FALSE) AND
                        (_instPhasingAbsolute.Error = FALSE) AND
                        (_instPhasingAbsolute.Done = FALSE) AND
                        (_instPhasingAbsolute.CommandAborted = FALSE)
                    THEN
                        // Return to NO_SELECTION if command finished
                        _supImpMotionState := NO_SELECTION;

                    ELSIF (_instPhasingAbsolute.Error = TRUE) THEN
                        // Errorhandling
                        _status := AxisStatus#ERR_MC_PHASINGABSOLUTE;
                        _statusText := STRING#'ERR_MC_PHASINGABSOLUTE';
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := WORD#0000;
                        _subfunctionStatus := _instPhasingAbsolute.ErrorId;
                        _changePhaseShiftOnTheFly := FALSE;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        _supImpMotionState := NO_SELECTION;
                    // ELSE
                    //   ; // Command busy
                    END_IF;
                    _exeOfSupImpMotionState := 16#0;
                    _exeOfSupImpMotionState.%X0 := _instPhasingAbsolute.Busy;
                    _exeOfSupImpMotionState.%X1 := _instPhasingAbsolute.Done;
                    _exeOfSupImpMotionState.%X2 := _instPhasingAbsolute.CommandAborted;
                    _exeOfSupImpMotionState.%X3 := _instPhasingAbsolute.Error;
                    _exeOfSupImpMotionState.%X4 := _instPhasingAbsolute.StartPhasing;
                ELSE
                    // Relative phasing
                    // Call MC_Command
                    _instPhasingRelative(Master := _refMasterAxis^,
                                         Slave := _refSyncAxis^,
                                         Execute := _supImpCommand.%X1); // Input: phasing

                    // Evaluate MC_Command
                    IF (_instPhasingRelative.Busy = FALSE) AND
                        (_instPhasingRelative.Error = FALSE) AND
                        (_instPhasingRelative.Done = FALSE) AND
                        (_instPhasingRelative.CommandAborted = FALSE)
                    THEN
                        // Return to NO_SELECTION if command finished
                        _supImpMotionState := NO_SELECTION;

                    ELSIF (_instPhasingRelative.Error = TRUE) THEN
                        // Errorhandling
                        _status := AxisStatus#ERR_MC_PHASINGRELATIVE;
                        _statusText := STRING#'ERR_MC_PHASINGRELATIVE';
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := _instPhasingRelative.ErrorId;
                        _subfunctionStatus := _instPhasingRelative.ErrorId;
                        _changePhaseShiftOnTheFly := FALSE;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        _supImpMotionState := NO_SELECTION;
                    // ELSE
                    //   ; // Command selected
                    END_IF;
                    _exeOfSupImpMotionState := 16#0;
                    _exeOfSupImpMotionState.%X0 := _instPhasingRelative.Busy;
                    _exeOfSupImpMotionState.%X1 := _instPhasingRelative.Done;
                    _exeOfSupImpMotionState.%X2 := _instPhasingRelative.CommandAborted;
                    _exeOfSupImpMotionState.%X3 := _instPhasingRelative.Error;
                    _exeOfSupImpMotionState.%X4 := _instPhasingRelative.StartPhasing;
                END_IF;

            OFFSET_SELECTED:

                // Firstcycle of command
                IF (_firstCycleSupImpMotion = TRUE) THEN
                    // Reset MC_OFFSET_ABSOLUTE command
                    _instOffsetAbsolute(Slave := _refSyncAxis^,
                                        Execute := FALSE);

                    // Reset MC_OFFSET_RELATIVE command
                    _instOffsetRelative(Slave := _refSyncAxis^,
                                        Execute := FALSE);

                    _instOffsetAbsolute.Offset := config.offset.offset;
                    _instOffsetRelative.Offset := config.offset.offset;
                    _offsetValue := config.offset.offset;

                    _instOffsetAbsolute.ProfileReference := config.offset.profileReference;
                    _instOffsetRelative.ProfileReference := config.offset.profileReference;
                    _instOffsetAbsolute.OffsetDistance := config.offset.offsetDistance;
                    _instOffsetRelative.OffsetDistance := config.offset.offsetDistance;
                    _instOffsetAbsolute.StartPosition := config.offset.startPosition;
                    _instOffsetRelative.StartPosition := config.offset.startPosition;
                    _instOffsetAbsolute.Direction := config.offset.direction;
                    _instOffsetRelative.Direction := config.offset.direction;

                    _offsetAbsolute := config.offset.offsetAbsolute;
                    _changeOffsetOnTheFly := config.offset.offsetChangeOnTheFly;

                ELSIF ((_changeOffsetOnTheFly = TRUE) AND
                    (config.offset.offset <> _offsetValue))
                    AND (_offsetAbsolute = TRUE)
                    AND (_instOffsetAbsolute.CommandAborted = FALSE)
                THEN
                    // Reset MC_OFFSET_ABSOLUTE command - Offset on the fly is only possible at offset absolute
                    _instOffsetAbsolute(Slave := _refSyncAxis^,
                                        Execute := FALSE);

                    _instOffsetAbsolute.Offset := config.offset.offset;
                    _offsetValue := config.offset.offset;
                END_IF;

                // Select offset absolute or relative
                IF (_offsetAbsolute = TRUE) THEN
                    // Absolute phasing
                    // Call MC_Command
                    _instOffsetAbsolute(Slave := _refSyncAxis^,
                                        Execute := _supImpCommand.%X2); // Input: offset

                    // Evaluate MC_Command
                    IF (_instOffsetAbsolute.Busy = FALSE) AND
                        (_instOffsetAbsolute.Error = FALSE) AND
                        (_instOffsetAbsolute.Done = FALSE) AND
                        (_instOffsetAbsolute.CommandAborted = FALSE)
                    THEN
                        // Return to NO_SELECTION if command finished
                        _supImpMotionState := NO_SELECTION;

                    ELSIF (_instOffsetAbsolute.Error = TRUE) THEN
                        // Errorhandling
                        _status := AxisStatus#ERR_MC_OFFSETABSOLUTE;
                        _statusText := STRING#'ERR_MC_OFFSETABSOLUTE';
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := _instOffsetAbsolute.ErrorId;
                        _subfunctionStatus := _instOffsetAbsolute.ErrorId;
                        _changeOffsetOnTheFly := FALSE;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        _supImpMotionState := NO_SELECTION;
                    // ELSE
                    //   ; // Command busy
                    END_IF;
                    _exeOfSupImpMotionState := 16#0;
                    _exeOfSupImpMotionState.%X0 := _instOffsetAbsolute.Busy;
                    _exeOfSupImpMotionState.%X1 := _instOffsetAbsolute.Done;
                    _exeOfSupImpMotionState.%X2 := _instOffsetAbsolute.CommandAborted;
                    _exeOfSupImpMotionState.%X3 := _instOffsetAbsolute.Error;
                    _exeOfSupImpMotionState.%X4 := _instOffsetAbsolute.StartOffset;
                ELSE
                    // Relative offset
                    // Call MC_Command
                    _instOffsetRelative(Slave := _refSyncAxis^,
                                        Execute := _supImpCommand.%X2); // Input: offset

                    // Evaluate MC_Command
                    IF (_instOffsetRelative.Busy = FALSE) AND
                        (_instOffsetRelative.Error = FALSE) AND
                        (_instOffsetRelative.Done = FALSE) AND
                        (_instOffsetRelative.CommandAborted = FALSE)
                    THEN
                        // Return to NO_SELECTION if command finished
                        _supImpMotionState := NO_SELECTION;

                    ELSIF (_instOffsetRelative.Error = TRUE) THEN
                        // Errorhandling
                        _status := AxisStatus#ERR_MC_OFFSETRELATIVE;
                        _statusText := STRING#'ERR_MC_OFFSETRELATIVE';
                        _errorAutoCleared := TRUE;
                        _diagnostics.subfunctionStatus := _instOffsetRelative.ErrorId;
                        _subfunctionStatus := _instOffsetRelative.ErrorId;
                        _changeOffsetOnTheFly := FALSE;
                        // Set next state
                        _state := AXIS_STOP_ON_ERROR_SELECTION;
                        _supImpMotionState := NO_SELECTION;
                    // ELSE
                    //   ; // Command selected
                    END_IF;
                    _exeOfSupImpMotionState := 16#0;
                    _exeOfSupImpMotionState.%X0 := _instOffsetRelative.Busy;
                    _exeOfSupImpMotionState.%X1 := _instOffsetRelative.Done;
                    _exeOfSupImpMotionState.%X2 := _instOffsetRelative.CommandAborted;
                    _exeOfSupImpMotionState.%X3 := _instOffsetRelative.Error;
                    _exeOfSupImpMotionState.%X4 := _instOffsetRelative.StartOffset;
                END_IF;

            ELSE
                // Errorhandling
                _status := AxisStatus#ERR_UNDEFINED_SUPERIMPOSED_MOTION_STATE;
                _statusText := STRING#'ERR_UNDEFINED_SUPERIMPOSED_MOTION_STATE';
                _errorUserCleared := TRUE;
                _diagnostics.subfunctionStatus := WORD#0000;
                _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                // Set errorstate
                _state := FB_ERROR;
        END_CASE;

        //----------------------------------------------------------------------------------------------
        // Execution of torquelimiting functionality
        //----------------------------------------------------------------------------------------------

        // Statemachine for torquelimiting
        REPEAT
            tempStateChangeActive := FALSE;
            CASE _torqueLimitingState OF
                NO_TORQUE_LIMITING_ACTIVE:
                    ;

                TORQUE_LIMITING_DISABLE:
                    // Torquelimiting disable
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := FALSE);

                    // Check state of torque limiting
                    IF (_instTorqueLimiting.Busy = FALSE) THEN
                        // set next state
                        _torqueLimitingState := NO_TORQUE_LIMITING_ACTIVE;
                    // ELSE
                        //   ; // Waiting for MC_TorqueLimiting is not busy
                    END_IF;

                TORQUE_LIMITING_SELECTED:
                    // No extended homing function active
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := _extendedCommand.%X1,
                                        Limit := config.torqueLimiting.limit,
                                        Mode := config.torqueLimiting.mode);

                    IF (_instTorqueLimiting.Busy = FALSE) THEN
                        // Reset state
                        _torqueLimitingState := NO_TORQUE_LIMITING_ACTIVE;
                    END_IF;

                FIXED_STOP_DETECTION_ACTIVE:
                    // Extended homing function active
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := TRUE,
                                        Limit := config.homing.extendedModeTorqueLimit, // Always use configured value
                                        Mode := MODE_FIXED_STOP_DETECTION);

                    IF ((_homingSubState = HOMING_IDLE) AND (_basicMotionState = ACTIVE_HOMING_SELECTED)) THEN
                        // Fixed stop process has finished - Axis is still in clamping
                        _torqueLimitingState := FIXED_STOP_DETECTION_FINISHED;
                        tempStateChangeActive := TRUE;
                    ELSIF (_basicMotionState <> ACTIVE_HOMING_SELECTED) THEN
                        // Error occurred - change state depending on inClamping
                        IF (_instTorqueLimiting.InClamping = TRUE) THEN
                            // Axis is in clamping
                            _torqueLimitingState := FIXED_STOP_DETECTION_ERROR_IN_CLAMPING;
                            tempStateChangeActive := TRUE;
                        ELSE
                            // Axis is in not clamping
                            _torqueLimitingState := FIXED_STOP_DETECTION_ERROR_NOT_IN_CLAMPING;
                            tempStateChangeActive := TRUE;
                        END_IF;
                    // ELSE
                    //   ; // Fixed stop detection is running
                    END_IF;

                FIXED_STOP_DETECTION_FINISHED:
                    // Homing on fixed stop process has finished
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := TRUE,
                                        Limit := config.homing.extendedModeTorqueLimit, // Always use configured value
                                        Mode := MODE_FIXED_STOP_DETECTION);

                    IF (_instTorqueLimiting.InClamping = FALSE) THEN
                        // InClamping = FALSE
                        IF (_extendedCommand.%X1 = TRUE) // Torquelimiting
                        THEN
                            _torqueLimitingState := TORQUE_LIMITING_SELECTED;
                        ELSE
                            _torqueLimitingState := TORQUE_LIMITING_DISABLE;
                        END_IF;
                        tempStateChangeActive := TRUE;
                    ELSE
                        // InClamping = TRUE
                        IF (_extendedCommand.%X1 = TRUE) // Torquelimiting
                            AND (config.torqueLimiting.mode = MODE_FIXED_STOP_DETECTION)
                        THEN
                            // Change State
                            _torqueLimitingState := TORQUE_LIMITING_SELECTED;
                            tempStateChangeActive := TRUE;
                        // ELSE
                        //   ; // Wait for inClamping = FALSE
                        END_IF;
                    END_IF;

                FIXED_STOP_DETECTION_ERROR_IN_CLAMPING:
                    // Errorstate, torquelimiting is still active and axis not in clamping
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := TRUE,
                                        Limit := config.homing.extendedModeTorqueLimit, // Always use configured value
                                        Mode := MODE_FIXED_STOP_DETECTION);

                    IF (_instTorqueLimiting.InClamping = FALSE) THEN
                        // InClamping = FALSE -> reset torque limiting state
                        _torqueLimitingState := TORQUE_LIMITING_DISABLE;
                        // Torquelimiting disable
                        tempStateChangeActive := TRUE;
                    END_IF;

                FIXED_STOP_DETECTION_ERROR_NOT_IN_CLAMPING:
                    // Errorstate, torquelimiting is still active and axis in clamping
                    _instTorqueLimiting(Axis := _refSpeedAxis^,
                                        Enable := TRUE,
                                        Limit := config.homing.extendedModeTorqueLimit, // Always use configured value
                                        Mode := MODE_FIXED_STOP_DETECTION);

                    IF (_instTorqueLimiting.InClamping = TRUE) THEN
                        // InClamping = TRUE -> change state
                        _torqueLimitingState := FIXED_STOP_DETECTION_ERROR_IN_CLAMPING;
                        tempStateChangeActive := TRUE;

                    ELSIF (_basicMotionState <> NO_SELECTION)
                        OR (_supImpMotionState <> NO_SELECTION)
                        OR (_passiveHomingState <> NO_HOMING_ACTIVE)
                    THEN
                        // New valid command is set -> reset error state
                        _torqueLimitingState := TORQUE_LIMITING_DISABLE;
                        tempStateChangeActive := TRUE;
                    // ELSE
                    //   ; // Waiting for new command or axis is getting in clamping
                    END_IF;
                ELSE
                    // Errorhandling
                    _status := AxisStatus#ERR_UNDEFINED_TORQUE_LIMITING_STATE;
                    _statusText := STRING#'ERR_UNDEFINED_TORQUE_LIMITING_STATE';
                    _errorUserCleared := TRUE;
                    _diagnostics.basicMotionState := _basicMotionState;
                    _diagnostics.superimposedMotionState := _supImpMotionState;
                    _diagnostics.subfunctionStatus := WORD#0000;
                    _subfunctionStatus := AxisStatus#STATUS_NO_CALL;
                    // Set errorstate
                    _state := FB_ERROR;
            END_CASE;
        UNTIL (tempStateChangeActive = FALSE)
        END_REPEAT;

        // Evaluate MC_Command
        IF (_instTorqueLimiting.Error = TRUE) AND ((_torqueLimitingErrorOld = FALSE) OR (_status = AxisStatus#STATUS_SUBSEQUENT_CALL)) THEN
            // Errorhandling
            _status := AxisStatus#ERR_MC_TORQUELIMITING;
            _statusText := STRING#'ERR_MC_TORQUELIMITING';
            _errorAutoCleared := TRUE;
            _diagnostics.basicMotionState := _basicMotionState;
            _diagnostics.superimposedMotionState := _supImpMotionState;
            _diagnostics.subfunctionStatus := _instTorqueLimiting.ErrorId;
            _subfunctionStatus := _instTorqueLimiting.ErrorId;

            _state := AXIS_STOP_ON_ERROR_SELECTION;

        ELSIF (_instTorqueLimiting.Error = FALSE) AND ((_torqueLimitingErrorOld = TRUE) AND (_status = AxisStatus#ERR_MC_TORQUELIMITING)) THEN
            _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
            _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
            _errorAutoCleared := FALSE;
        END_IF;

        _torqueLimitingErrorOld := _instTorqueLimiting.Error;

        //----------------------------------------------------------------------------------------------
        // Selection of StopOnError / implementation of fastStop
        //----------------------------------------------------------------------------------------------

        // Check for stopping if error occurred during execution of motion commands
        IF (_state = AXIS_STOP_ON_ERROR_SELECTION) THEN
            _basicMotionState := NO_SELECTION;
            _supImpMotionState := NO_SELECTION;
            _passiveHomingState := NO_HOMING_ACTIVE;

            IF (config.generalSettings.stopOnError = TRUE) THEN
                // Evaluate error
                IF tempStatusWord.%X0 THEN
                    // Axis enabled
                    IF (tempStatusWord.%X1 = TRUE) THEN
                        // TO Alarm present
                        _state := AXIS_MOTION;
                    ELSE
                        _stopWithoutSignalization := TRUE;
                        _firstCycleBasicMotion := TRUE;
                        _state := AXIS_STOP_ON_ERROR_EXECUTION;
                    END_IF;
                ELSE
                // Axis disabled
                _state := AXIS_MOTION;
                END_IF;
            ELSE
                // Dont StopOnError
                _state := AXIS_MOTION;
            END_IF;
        END_IF;

        // Implementation of fastStop
        IF _stopWithoutSignalization
            OR
            (
            TRUE
            AND (_basicMotionState = FAST_STOP_SELECTED)
            AND (_mainSelectionState = CALL_BASIC_MOTION)
            )
        THEN
            // Additional feature: Load emergency stop dynamics (TO) if no valid dynamics are configured for fastStop

            // Firstcycle of command
            IF (_firstCycleBasicMotion = TRUE) THEN
                // Reset HALT command
                _instHalt(Axis := _refSpeedAxis^,
                          Execute := FALSE,
                          Mode := 0); // Mode := 0 "The basic motion and the superimposed motion are stopped." MC_Halt instance is also used for input 'stop', where the 'haltMode' can now be specified via config

                _firstCycleDone := TRUE;
                // Check dynamics for fastStop
                // Load TO emergency Stop dynamics if value <=0 for deceleration is configured
                IF (config.fastStop.deceleration <= 0.0) // Read TO emergencyStop deceleration only if fastStop.deceleration <= 0
                THEN
                    // Invalid fastStop dynamics configured - read emergency stop dynamics from TO
                    IF (_refSpeedAxis <> NULL) THEN // Axis type is TO_SpeedAxis or TO_PositioningAxis or TO_SynchronousAxis
                        _instHalt.Deceleration := _refSpeedAxis^.DynamicDefaults.EmergencyDeceleration;
                    ELSE // Invalid TO specification
                        _instHalt.Deceleration := -1.0;
                    END_IF;
                ELSE
                    // Valid fastStop dynamics configured
                    _instHalt.Deceleration := config.fastStop.deceleration;
                END_IF;
                _instHalt.AbortAcceleration := config.fastStop.abortAcceleration; // Use always config
                _instHalt.Jerk := config.fastStop.jerk; // Use always config for jerk value
            END_IF;

            // Call of MC_Command
            _instHalt(Axis := _refSpeedAxis^,
                      Execute := (_basicCommand.%X0 OR _firstCycleBasicMotion));

            // Evaluate MC_Command
            IF (_instHalt.Busy = FALSE) AND
                (_instHalt.Error = FALSE) AND
                (_instHalt.Done = FALSE) AND
                (_instHalt.CommandAborted = FALSE)
            THEN
                // Return to NO_SELECTION if command finished
                _state := AXIS_MOTION;
                _basicMotionState := NO_SELECTION;
                _stopWithoutSignalization := FALSE;

            ELSIF (_instHalt.Done = TRUE) THEN
                IF (_firstCycleDone = TRUE) THEN
                    // Command is reset
                    IF (_instTorqueLimiting.Error = FALSE) // Dont reset error is pending
                    THEN
                        // Reset status not if torquelimiting error is pending
                        IF _stopWithoutSignalization THEN
                            ;
                        ELSE
                            _status := AxisStatus#STATUS_SUBSEQUENT_CALL;
                            _statusText := STRING#'STATUS_SUBSEQUENT_CALL';
                            _errorAutoCleared := FALSE;
                        END_IF;
                    END_IF;

                    _firstCycleDone := FALSE;
                END_IF;

            ELSIF (_instHalt.Error = TRUE) AND (_stopWithoutSignalization = FALSE) // signal the error if fastStop is selected via the input 'fastStop'
            THEN
                // Errorhandling
                _status := AxisStatus#ERR_MC_HALT;
                _statusText := STRING#'ERR_MC_HALT';
                _errorAutoCleared := TRUE;
                _diagnostics.subfunctionStatus := _instHalt.ErrorId;
                _subfunctionStatus := _instHalt.ErrorId;

                IF (config.fastStop.replaceStopPossible = TRUE) THEN
                    // Set next state
                    _basicMotionState := NO_SELECTION;
                END_IF;

            // ELSE
            //   ; // Command selected
            END_IF;

            // Write MC_Command outputs to internal variable
            _exeOfBasicMotion := 0;
            _exeOfBasicMotion.%X0 := _instHalt.Busy;
            _exeOfBasicMotion.%X1 := _instHalt.Done;
            _exeOfBasicMotion.%X2 := _instHalt.CommandAborted;
            _exeOfBasicMotion.%X3 := _instHalt.Error;

        END_IF;

        //----------------------------------------------------------------------------------------------
        // Store values and reset variables
        //----------------------------------------------------------------------------------------------

        // Reset variables to determine first cycle of a new command
        IF (_firstCycleReset = TRUE) THEN
            _firstCycleReset := FALSE;
        END_IF;
        IF (_firstCycleHoming = TRUE) THEN
            _firstCycleHoming := FALSE;
        END_IF;
        _homingOld := tempHoming;

        _firstCycleBasicMotion := FALSE;
        _basicCommandOld := _basicCommand;

        IF (_firstCycleSupImpMotion = TRUE) THEN
            _firstCycleSupImpMotion := FALSE;
        END_IF;
        _supImpCommandOld := _supImpCommand;

        // Store last values for edge detection
        _enableOld := tempEnable;
        _enableAxisOld := tempEnableAxis;
        _extendedCommandOld := _extendedCommand;
        _powerErrorOld := _instPower.Error;

        //----------------------------------------------------------------------------------------------
        // Writing outputs
        //----------------------------------------------------------------------------------------------

        // Writing status outputs
        resetActive := (_resetState = CMD_BUSY);

        IF (_errorUserCleared = TRUE) THEN
            ; // Reset variables at ErrorUserCleared
            _basicMotionState := NO_SELECTION;
            _exeOfBasicMotion := NO_SELECTION;
            _supImpMotionState := NO_SELECTION;
            _exeOfSupImpMotionState := NO_SELECTION;
            _exeOfHoming := NO_SELECTION;
        END_IF;

        IF (config.power.externalMC_PowerCall = FALSE) THEN
            // Generate the 'axisEnabled' status via the status of the MC_Power instance
            IF (_instPower.Status = TRUE) THEN
                // Axis enabled
                axisEnabled := TRUE;

            ELSIF (_instPower.Error = TRUE) AND (_instPower.Status = FALSE) THEN
                // Reset status if error occurred
                axisEnabled := FALSE;

            ELSIF (_instPower.Busy = FALSE) THEN
                // Reset if MC_Power is not busy
                axisEnabled := FALSE;
            END_IF;

        ELSE // (config.power.externalMC_PowerCall = TRUE)
            // Generate the 'axisEnabled' status via StatusWord Bit 0
            axisEnabled := tempStatusWord.%X0; // StatusWord Bit 0: Enable status. The technology object has been enabled
        END_IF;

        // Writing Busy, Done and Aborted outputs for basic motion commands
        IF (_basicMotionState > NO_SELECTION) AND (_basicMotionState <> ACTIVE_HOMING_SELECTED) THEN
            commandBusy := _exeOfBasicMotion.%X0;
            commandDone := _exeOfBasicMotion.%X1;
            commandAborted := _exeOfBasicMotion.%X2;
            inVelocity := _exeOfBasicMotion.%X4;
            inSync := _exeOfBasicMotion.%X7;
            startSync := _exeOfBasicMotion.%X6;
            endOfProfile := _exeOfBasicMotion.%X8;
        ELSE
            commandBusy := FALSE;
            commandDone := FALSE;
            commandAborted := FALSE;
            inVelocity := FALSE;
            inSync := FALSE;
            startSync := FALSE;
            endOfProfile := FALSE;
        END_IF;

        // Writing outputs up to LAxisCtrl_SpeedAxis
        IF (_torqueLimitingState = TORQUE_LIMITING_SELECTED) THEN
            torqueLimitingSelected := TRUE;
        ELSE
            torqueLimitingSelected := FALSE;
        END_IF;

        inLimitation := _instTorqueLimiting.InLimitation;
        fastStopSelected := _basicMotionState.%X0;
        stopSelected := _basicMotionState.%X1;
        jogSelected := _basicMotionState.%X2 OR _basicMotionState.%X3;
        moveVelocitySelected := _basicMotionState.%X4;
        // Writing outputs up to LAxisCtrl_PosAxis
        inClamping := _instTorqueLimiting.InClamping;
        posRelativeSelected := _basicMotionState.%X5;
        posAbsoluteSelected := _basicMotionState.%X6;
        // Writing outputs up to LAxisCtrl_SyncAxisRelGearing
        gearInRelativeSelected := _basicMotionState.%X7;
        // Writing outputs up to LAxisCtrl_SyncAxisCamming
        gearInAbsoluteSelected := _basicMotionState.%X8;
        gearInVelocitySelected := _basicMotionState.%X12;
        camInSelected := _basicMotionState.%X9;
        gearOutCamOutSelected := _basicMotionState.%X11;
        inSimulation := _instSyncMotionSimulation.InSimulation;

        // Writing Busy, Done and Aborted outputs for homing
        IF (_passiveHomingState = STANDARD_HOMING) THEN
            homingSelected := TRUE;
            homingCommandBusy := _exeOfHoming.%X0;
            homingCommandDone := _exeOfHoming.%X1;
            homingCommandAborted := _exeOfHoming.%X2;
        ELSE
            IF (_basicMotionState = ACTIVE_HOMING_SELECTED) THEN
                homingSelected := TRUE;
                homingCommandBusy := _exeOfBasicMotion.%X0;
                homingCommandDone := _exeOfBasicMotion.%X1;
                homingCommandAborted := _exeOfBasicMotion.%X2;
            ELSE
                homingSelected := FALSE;
                homingCommandBusy := FALSE;
                homingCommandDone := FALSE;
                homingCommandAborted := FALSE;
            END_IF;
        END_IF;

        // Writing outputs for superimposed motion commands
        IF (_supImpMotionState <> NO_SELECTION) THEN
            superimposedBusy := _exeOfSupImpMotionState.%X0;
            superimposedDone := _exeOfSupImpMotionState.%X1;
            superimposedAborted := _exeOfSupImpMotionState.%X2;
            superimposedStart := _exeOfSupImpMotionState.%X4;
        ELSE
            superimposedBusy := FALSE;
            superimposedDone := FALSE;
            superimposedAborted := FALSE;
            superimposedStart := FALSE;
        END_IF;

        posSuperimposedSelected := _supImpMotionState.%X0;
        haltSuperimposedSelected := _supImpMotionState.%X3;
        phasingSelected := _supImpMotionState.%X1;
        offsetSelected := _supImpMotionState.%X2;

        //----------------------------------------------------------------------------------------------
        // Error handling
        //----------------------------------------------------------------------------------------------

        IF _errorUserCleared THEN
            valid := FALSE;
            busy := TRUE;
            error := TRUE;
            subfunctionStatus := _subfunctionStatus;
            _diagnostics.status := _status;

        ELSIF _errorAutoCleared THEN
            valid := FALSE;
            busy := TRUE;
            error := TRUE;
            subfunctionStatus := _subfunctionStatus;
            _diagnostics.status := _status;

        ELSE
            // Process normal output values
            valid := TRUE;
            error := FALSE;
            subfunctionStatus := WORD#16#0000;
            _subfunctionStatus := WORD#16#0000;
        END_IF;

        status := _status;

        IF (_status <> _statusOld) THEN
            statusText := _statusText;
            diagnostics := _diagnostics;
        END_IF;

        // Edge detection
        _statusOld := _status;

    END_FUNCTION_BLOCK
END_NAMESPACE
