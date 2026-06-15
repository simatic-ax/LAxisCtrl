NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeMoveVelocity : STRUCT
            /// Velocity/Speed for motion process (Value = 0.0: Permitted)
            velocity : LREAL := 0.0;
            /// Acceleration setpoINT for motion process (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration setpo  for motion process (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for velocity specification (Value > 0.0: Smooth velocity profile, the specified value is used; (Value = 0.0: Trapezoid velocity profile; (Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// Motion direction of the axis (0: The sign of the velocity parameter defines the direction; 1: Positive direction; 2: Negative direction)
            direction : MoveVelocityDirection;
            /// TRUE: Position-controlled operation; FALSE: Non position-controlled operation
            positionControlled : BOOL := TRUE;
            /// TRUE: Changing velocity on-the-fly while the command is active and the corresponding input is set; FALSE: Velocity change requires a new rising edge on moveVelocity input
            velocityChangeOnTheFly : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
