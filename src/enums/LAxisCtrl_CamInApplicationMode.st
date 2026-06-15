NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        CamInApplicationMode : DINT (
            /// Once, non-cyclic
            ONCE := 0,
            /// Cyclic (absolute application on the following value side)
            CYCLIC_ABS := 1,
            /// Cyclic appending (continuously appending on the following value side)
            CYCLIC_APPEND := 2
        ) := ONCE;
    END_TYPE
END_NAMESPACE
