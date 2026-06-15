NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        MoveVelocityDirection : INT (
            /// The sign of the velocity specified at the 'Veloctiy' parameter defines the direction of the rotation
            DEFINED_BY_SIGN_OF_VELOCITY := 0,
            // Positive direction
            POSITIVE := 1,
            /// Negative direction
            NEGATIVE := 2
        ) := DEFINED_BY_SIGN_OF_VELOCITY;
    END_TYPE
END_NAMESPACE
