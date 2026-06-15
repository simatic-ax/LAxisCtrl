NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typePosRelative : STRUCT
            /// Distance for positioning process
            distance : LREAL := 0.0;
            /// Velocity setpoint for relative positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            velocity : LREAL := -1.0;
            /// Acceleration setpoint for relative positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration setpoint for relative positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for relative positioning (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// Motion direction of the axis (0: The sign of the distance parameter defines the direction; 1: Positive direction; 2: Negative direction)
            direction : PosRelDirection;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
