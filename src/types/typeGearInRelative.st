NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeGearInRelative : STRUCT
            /// Gear ratio numerator (permitted integer values: -2147483648 to 2147483647; value 0 not permitted)
            ratioNumerator : DINT := 1;
            /// Gear ratio denominator (permitted integer values: 1 to 2147483647)
            ratioDenominator : DINT := 1;
            /// Acceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration for synchronization (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for synchronization (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// TRUE: Changing gear ratio on-the-fly while the command is active and the corresponding input is set; FALSE: Ratio change requires a new rising edge at gearInRelative input
            ratioChangeOnTheFly : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
