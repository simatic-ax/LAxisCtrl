NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typePosAbsolute : STRUCT
            /// Absolute target position
            position : LREAL := 0.0;
            /// Velocity setpoint for absolute positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            velocity : LREAL := -1.0;
            /// Acceleration setpoint for absolute positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration setpoint for absolute positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for absolute positioning (Value > 0.0: Smooth velocity profile, the specified value is used; (Value = 0.0: Trapezoid velocity profile; (Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// Motion direction of the axis (1: Positive direction; 2: Negative direction; 3: Shortest way)
            direction : PosAbsDirection;
            /// TRUE: Changing position on-the-fly while the command is active and the corresponding input is set; FALSE: Position change requires a new rising edge at posAbsolute input
            positionChangeOnTheFly : BOOL := FALSE;
            /// TRUE: Changing velocity on-the-fly while the command is active and the corresponding input is set; FALSE: Velocity change requires a new rising edge at posAbsolute input
            velocityChangeOnTheFly : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
