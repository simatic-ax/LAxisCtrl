# AxisStatus

| Symbol | Value | Description |
| ------ | ----- | ----------- |
| STATUS_NO_CALL | WORD#16#7000 | No call of FB |
| STATUS_FB_FIRST_CALL | WORD#16#7001 | First cycle of FB after enabling |
| STATUS_SUBSEQUENT_CALL | WORD#16#7002 | FB enabled |
| ERR_INVALID_BASIC_MOTION_CMD | WORD#16#8001 | Invalid basic command selected (rising edge at 2 or more basic motion command inputs) |
| ERR_INVALID_EXTENDED_CMD | WORD#16#8002 | Invalid extended command selected (rising edge at torque limiting and homing on fixed stop) |
| ERR_INVALID_SUPERIMPOSED_MOTION_CMD | WORD#16#8003 | Invalid superimposed command selected (rising edge at 2 or more superimposed motion command inputs) |
| ERR_INVALID_JOG_MODE | WORD#16#8201 | Invalid jog mode selected |
| ERR_INVALID_HOMING_EXTENDED_MODE | WORD#16#8202 | Command Error: Invalid extended homing mode selected |
| ERR_TORQUE_LIMITING_NOT_ALLOWED | WORD#16#8203 | Error during extended homing command - torque limiting not allowed during homing on fixed stop is active or axis in clamping |
| ERR_INVALID_JOG_DIR | WORD#16#8204 | Invalid direction selected (jog forward and jog backward) |
| ERR_INVALID_POS_RELATIVE_DIR | WORD#16#8205 | Invalid direction is set for relative positioning command |
| ERR_INVALID_POS_SUPERIMPOSED_DIR | WORD#16#8206 | Invalid direction is set for superimposed positioning command |
| ERR_HOMING_MODE_NOT_ALLOWED | WORD#16#8207 | Passive/Direct homing is not allowed during extended homing mode (homing on fixed stop process) is active |
| ERR_MODULO_NOT_ALLOWED | WORD#16#8208 | Extended homing mode (homing on fixed stop process) is not allowed with modulo axis |
| ERR_INVALID_TORQUE_LIMIT | WORD#16#8209 | Configured torque limit value for extended homing mode (homing on fixed stop process) = 0 |
| ERR_INVALID_VELOCITY | WORD#16#820A | Configured velocity (in technology object) for active homing = 0 |
| ERR_INVALID_AXIS | WORD#16#820B | Illegal specification of the technology object |
| ERR_INVALID_TARGET_POSITION | WORD#16#820C | Invalid target position configured for extended homing mode |
| ERR_INVALID_GEAROUT_CAMOUT_MODE | WORD#16#820D | Error invalid mode for gearOutCamOut instruction |
| ERR_INVALID_SYNCHRONIZED_EXTENDED_MODE | WORD#16#820E | Error invalid extended mode for synchronized motion simulation functionality |
| ERR_MC_POWER | WORD#16#8600 | Error occurred during MC_POWER command |
| ERR_MC_RESET | WORD#16#8601 | Error occurred during MC_RESET command |
| ERR_MC_HOME | WORD#16#8602 | Error occurred during MC_HOME command |
| ERR_MC_TORQUELIMITING | WORD#16#8603 | Error occurred during MC_TORQUELIMITING command |
| ERR_MC_HALT | WORD#16#8604 | Error occurred during MC_HALT command |
| ERR_MC_MOVEJOG | WORD#16#8605 | Error occurred during MC_MOVEJOG command (continuous jogging) |
| ERR_MC_MOVEVELOCITY | WORD#16#8606 | Error occurred during MC_MOVEVELOCITY command |
| ERR_MC_MOVERELATIVE | WORD#16#8607 | Error occurred during MC_MOVERELATIVE command |
| ERR_MC_MOVEABSOLUTE | WORD#16#8608 | Error occurred during MC_MOVEABSOLUTE command |
| ERR_MC_MOVESUPERIMPOSED | WORD#16#8609 | Error occurred during MC_MOVESUPERIMPOSED command |
| ERR_MC_GEARIN | WORD#16#860A | Error occurred during MC_GEARIN command |
| ERR_MC_PHASINGABSOLUTE | WORD#16#860B | Error occurred during MC_PHASINGABSOLUTE command |
| ERR_MC_PHASINGRELATIVE | WORD#16#860C | Error occurred during MC_PHASINGRELATIVE command |
| ERR_MC_CAMIN | WORD#16#860D | Error occurred during MC_CAMIN command |
| ERR_MC_GEARINPOS | WORD#16#860E | Error occurred during MC_GEARINPOS command |
| ERR_MC_SYNCHRONIZEDMOTIONSIMULATION | WORD#16#860F | Error occurred during MC_SYNCHRONIZEDMOTIONSIMULATION command |
| ERR_MC_OFFSETABSOLUTE | WORD#16#8610 | Error occurred during MC_OFFSETABSOLUTE command |
| ERR_MC_OFFSETRELATIVE | WORD#16#8611 | Error occurred during MC_OFFSETRELATIVE command |
| ERR_MC_CAMOUT | WORD#16#8612 | Error occurred during MC_CAMOUT command |
| ERR_MC_GEAROUT | WORD#16#8613 | Error occurred during MC_GEAROUT command |
| ERR_MC_HALTSUPERIMPOSED | WORD#16#8614 | Error occurred during MC_HALTSUPERIMPOSED command |
| ERR_MC_GEARINVELOCITY | WORD#16#8615 | Error occurred during MC_GEARINVELOCITY command |
| ERR_UNDEFINED_FB_STATE | WORD#16#8700 | Error due to an undefined FB state |
| ERR_UNDEFINED_RESET_STATE | WORD#16#8701 | Error due to an undefined reset state |
| ERR_UNDEFINED_BASIC_MOTION_STATE | WORD#16#8702 | Error due to an undefined basic motion state |
| ERR_UNDEFINED_TORQUE_LIMITING_STATE | WORD#16#8703 | Error due to an undefined torque limiting state |
| ERR_UNDEFINED_INCREMENTAL_JOG_STATE | WORD#16#8704 | Error due to an undefined incremental jog state |
| ERR_UNDEFINED_INCREMENTAL_JOG_SUBSTATE | WORD#16#8705 | Error due to an undefined incremental jog substate |
| ERR_UNDEFINED_EXTENDED_HOMING_STATE | WORD#16#8706 | Error due to an undefined homing state |
| ERR_UNDEFINED_EXTENDED_HOMING_SUBSTATE | WORD#16#8707 | Error due to an undefined homing substate |
| ERR_UNDEFINED_SUPERIMPOSED_MOTION_STATE | WORD#16#8708 | Error due to an undefined superimposed motion state |
| ERR_UNDEFINED_MOTION_SIMULATION_STATE | WORD#16#8709 | Error due to an undefined synchronized motion simulation state |
| ERR_UNDEFINED_MAIN_SELECTION_STATE | WORD#16#870A | Error due to an undefined main selection state |
