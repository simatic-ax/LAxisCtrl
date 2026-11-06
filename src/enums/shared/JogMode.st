NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Mode for jogging operation.
        JogMode : INT (
            /// Continous jogging.
            CONTINOUS := INT#0,
            /// Incremental jogging .
            INCREMENTAL := INT#1,
            /// Incremental jogging continuing previous incomplete increment.
            CONTINUE_INCREMENT := INT#2
        ) := CONTINOUS;
    END_TYPE
END_NAMESPACE
