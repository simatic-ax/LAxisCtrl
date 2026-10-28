NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeJog : STRUCT
            /// Velocity for jogging (Value > 0.0: The specified value is used; Value = 0.0: Permitted; Value < 0.0: The absolute value of the specified value is used)
            velocity : LREAL := 0.0;
            /// Acceleration for jogging (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration for jogging (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for jogging (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// TRUE: Position-controlled mode; FALSE: Non position-controlled operation
            positionControlled : BOOL := TRUE;
            /// Increment/distance for incremental jogging
            increment : LREAL := 0.0;
            /// 0: Continuous jogging; 1: Incremental jogging new increment (starts with new increment); 2: Incremental jogging continue increment (continue the last increment if not completed)
            mode : JogMode;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
