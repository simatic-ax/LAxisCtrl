NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typePosSuperimposed : STRUCT
            /// Distance for superimposed positioning
            distance : LREAL := 0.0;
            /// Maximum velocity deviation compared to the active motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            velocityDiff : LREAL := -1.0;
            /// Acceleration for positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration for positioning (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for positioning (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// Motion direction of the axis (0: The sign of the distance parameter defines the direction; 1: Positive direction; 2: Negative direction)
            direction : PosSuperimposedDirection;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
