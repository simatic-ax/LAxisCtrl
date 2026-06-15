NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeGeneralSettings : STRUCT
            /// TRUE: In case of error the axis will be stopped automatically with fastStop dynamics
            stopOnError : BOOL := TRUE;
            /// TRUE: Reinitialization of the technology object and acknowledgment of pending technology alarms. The technology object is reinitialized with the configured start values; FALSE: Acknowledgment of queued technology alarms
            resetWithRestart : BOOL := FALSE;
            /// TRUE: Abort waiting synchronous command (MC_GEARINPOS, MC_CAMIN) in case of new basic motion command automatically
            abortWaitingSyncCmd : BOOL := TRUE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
