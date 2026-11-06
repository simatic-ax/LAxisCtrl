NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Mode of the camming operation.
        CamApplicationMode : DINT(
            /// Runs the cam profile once.
            ONCE := DINT#0,
            /// Runs the cam profile cyclic (absolute on the following value side).
            CYCLIC := DINT#1,
            /// Runs the cam profile cyclc (continously appending on the following value side).
            CYCLIC_APPENDING := DINT#2
        ) := ONCE;
    END_TYPE
END_NAMESPACE
