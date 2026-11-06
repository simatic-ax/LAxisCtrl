NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeFastStopParams : STRUCT
            /// Mode for dynamic behavior (0: Emergency stop; 1: Not permitted; 2: Stop with maximum dynamic values; 3: Stop with specified dynamics). See corresponding parameter of MC_ instruction in TIA Portal help (information system)
            mode : DINT;   
            /// Only relevant if 'mode' = 3: Deceleration for the braking ramp (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The deceleration configured in "Technology object > Configuration > Extended parameters > Dynamic defaults" is used -> <TO>.DynamicDefaults.Deceleration)
            deceleration : LREAL := -1.0;   
            /// Only relevant if 'mode' = 3: Jerk for the braking ramp (Value > 0.0: The specified value is used; Value = 0.0: No jerk limitation; Value < 0.0: The jerk configured in "Technology object > Configuration > Extended parameters > Dynamic defaults" is used -> <TO>.DynamicDefaults.Jerk)
            jerk : LREAL := -1.0;   
            /// TRUE: Acceleration is set to 0.0. The configured deceleration is built up immediately; FALSE: The acceleration is reduced using the configured jerk. The configured deceleration then builds up
            abortAcceleration : BOOL;   
        END_STRUCT;
    END_TYPE
END_NAMESPACE
