NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typePhasing : STRUCT
            /// Absolute or relative leading value shift
            phaseShift : LREAL := 0.0;
            /// Velocity for leading value shift, added to synchronous operation motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            velocity : LREAL := -1.0;
            /// Acceleration for leading value shift, added to synchronous operation motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            acceleration : LREAL := -1.0;
            /// Deceleration for leading value shift, added to synchronous operation motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for leading value shift, added to synchronous operation motion (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// Type of traversing of the leading value offset (0: Only with gearing: Traverse leading value offset using dynamics parameters; 1: Traverse leading value offset via leading value distance starting from current leading value position; 2: Traverse leading value offset from leading value position "StartPosition"; 5: Cancel only one waiting job for the leading value offset)
            profileReference : PhasingProfileReference;
            /// Leading value distance (Distance of the leading axis during the traversing of the leading value offset) when "ProfileReference" = 1, 2
            phasingDistance : LREAL;
            /// Leading value position starting from which the leading value offset is traversed when "ProfileReference" = 2
            startPosition : LREAL;
            /// Direction of the leading value distance (1: Positive direction; 2: Negative direction; 3: Current direction) when "ProfileReference" = 1, 2
            direction : PhasingDirection;
            /// Indicates the type of phase shift. TRUE: Shift the leading value as an absolute shift; FALSE: Shift the leading value relative to the existing leading value shift
            phaseAbsolute : BOOL := TRUE;
            /// TRUE: Changing phase shift on-the-fly at absolute phasing while the command is active and the corresponding input is set; FALSE: Phase shift change requires a new rising edge at phasing input
            phaseShiftChangeOnTheFly : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
