NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeFastStop : STRUCT
            /// Deceleration for fast stop (Value > 0.0: The specified value is used; Value <= 0.0: Emergency deceleration of the technology object is used)
            deceleration : LREAL := -1.0;
            /// Jerk for fast stop (Value > 0.0: Smooth velocity profile, the specified value is used; Value = 0.0: Trapezoid velocity profile; Value < 0.0: Use of the default value configured in the technology object)
            jerk : LREAL := -1.0;
            /// TRUE: The acceleration is set to 0.0 at the start of the job, and the deceleration immediately builds up; FALSE: The current acceleration at the start of the job is reduced using the configured jerk. Afterwards, the deceleration builds up
            abortAcceleration : BOOL := FALSE;
            /// TRUE: Fast stop command can be replaced by another command
            replaceStopPossible : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
