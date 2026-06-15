NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        typeOffset : STRUCT
            /// Absolute or relative offset shift
            offset : LREAL := 0.0;
            /// Type of traversing of the following value offset (0: Only with gearing, 1: Traverse following value offset using leading value distance starting from the current effective leading value position; 2: Traverse following value offset using leading value distance from the effective leading value position "StartPosition"; 5: Cancel only one waiting job for the following value offset)
            profileReference : OffsetProfileReference;
            /// Effective leading value distance while traversing the following value offset when "ProfileReference" = 1, 2
            offsetDistance : LREAL;
            /// Effective leading value position starting from which the following value offset is traversed when "ProfileReference" = 2
            startPosition : LREAL;
            /// Direction of the leading value distance (1: Positive direction; 2: Negative direction; 3: Current direction) when "ProfileReference" = 1, 2
            direction : OffsetDirection;
            /// Indicates the type of the offset shift. TRUE: Shift the following value as an absolute shift; FALSE: Shift the following value relative to the existing following value shift
            offsetAbsolute : BOOL := TRUE;
            /// TRUE: Changing offset shift on-the-fly at absolute offset shift while the command is active and the corresponding input is set; FALSE: Offset shift change requires a new rising edge at offset input
            offsetChangeOnTheFly : BOOL := FALSE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
