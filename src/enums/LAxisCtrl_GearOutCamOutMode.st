NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        GearOutCamOutMode : DINT (
            /// Automatic detection whether to use a MC_GearOut or MC_CamOut
            AUTOMATIC := -1,
            /// Use MC_GearOut
            USE_GEAROUT := 0,
            /// Use MC_CamOut
            USE_CAMOUT := 1
        ) := AUTOMATIC;
    END_TYPE
END_NAMESPACE
