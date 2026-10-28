NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeHaltSuperimposed : STRUCT
            /// Deceleration of the superimposed motion (Value > 0.0: The specified value is used; Value = 0.0: Not permitted; Value < 0.0: The deceleration configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. <TO>.DynamicDefaults.Deceleration)
            deceleration : LREAL := -1.0;
            /// Jerk of the superimposed motion (Value > 0.0: Constant-acceleration velocity profile of the superimposed motion; the specified jerk is used; Value = 0.0: Trapezoidal velocity profile of the superimposed motion; Value < 0.0: The jerk configured in "Technology object > Configuration > Extended parameters > Dynamic default values" is used. <TO>.DynamicDefaults.Jerk)
            jerk : LREAL := -1.0;
            /// TRUE: The acceleration of the superimposed motion is set to 0.0 at the start of the job, the deceleration builds up immediately; FALSE: The current acceleration of the superimposed motion at the start of the job is reduced using the configured jerk. Afterwards, the deceleration builds up
            abortAcceleration : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
