NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeAxisConfig : STRUCT
            /// Configuration of general settings
            generalSettings : typeGeneralSettings;
            /// Configuration of MC_POWER function
            power : typePower;
            /// Configuration of JOG function
            jog : typeJog;
            /// Configuration of MC_MOVEVELOCITY function
            moveVelocity : typeMoveVelocity;
            /// Configuration of MC_HALT function
            stop : typeStop;
            /// Configuration of MC_HALT function (alternative dynamics)
            fastStop : typeFastStop;
            /// Configuration of MC_TORQUELIMITING function
            torqueLimiting : typeTorqueLimiting;
            /// Configuration of HOMING function
            homing : typeHoming;
            /// Configuration of MC_MOVERELATIVE function
            posRelative : typePosRelative;
            /// Configuration of MC_MOVEABSOLUTE function
            posAbsolute : typePosAbsolute;
            /// Configuration of MC_MOVESUPERIMPOSED function
            posSuperimposed : typePosSuperimposed;
            /// Configuration of MC_HALTSUPERIMPOSED function
            haltSuperimposed : typeHaltSuperimposed;
            /// Configuration of MC_GEARIN function
            gearInRelative : typeGearInRelative;
            /// Configuration of MC_GEARIN_POS function
            gearInAbsolute : typeGearInAbsolute;
            /// Configuration of MC_GEARINVELOCITY function
            gearInVelocity : typeGearInVelocity;
            /// Configuration of MC_CAMIN function
            camIn : typeCamIn;
            /// Configuration of MC_GEAROUT / MC_CAMOUT function
            gearOutCamOut : typeGearOutCamOut;
            /// Configuration of MC_PHASING function
            phasing : typePhasing;
            /// Configuration of MC_OFFSET function
            offset : typeOffset;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
