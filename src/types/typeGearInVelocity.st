NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeGearInVelocity : STRUCT
            /// TRUE: Specify gear ratio continuously; FALSE: Specify gear ratio once at the start of the job with a positive edge
            continuousUpdate : BOOL := FALSE;
            /// Gear ratio numerator (permitted integer values: -2147483648 to 2147483647; value 0 not permitted)
            ratioNumerator : DINT := 1;
            /// Gear ratio denominator (permitted integer values: 1 to 2147483647)
            ratioDenominator : DINT := 1;
            /// Acceleration for the synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The acceleration configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. <TO>.DynamicDefaults.Acceleration)
            acceleration : LREAL := -1.0;
            /// Deceleration for the synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The deceleration configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. <TO>.DynamicDefaults.Deceleration)
            deceleration : LREAL := -1.0;
            /// Jerk for the synchronization (Value > 0.0: The specified value is used; Value = 0.0: No jerk limitation; Value < 0.0: The jerk configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. <TO>.DynamicDefaults.Jerk)
            jerk : LREAL := -1.0;
            /// Position control of the following axis (TRUE: Position-controlled mode; FALSE: Non-position-controlled operation)
            positionControlled : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
