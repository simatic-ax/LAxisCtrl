NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeStop : STRUCT
            /// Deceleration setpoint for stop (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: Use of the default value configured in the technology object)
            deceleration : LREAL := -1.0;
            /// Jerk for stop (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// TRUE: The acceleration is set to 0.0 at the start of the job, and the deceleration immediately builds up; FALSE: The current acceleration at the start of the job is reduced using the configured jerk. Afterwards, the deceleration builds up
            abortAcceleration : BOOL := FALSE;
            /// Select the motion which is to be stopped (0: The basic motion and the superimposed motion are stopped; 1: The basic motion is stopped. The superimposed motion remains active)
            haltMode : HaltMode;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
