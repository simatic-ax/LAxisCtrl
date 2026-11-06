NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Direction for a move velocity command.
        Direction : INT (
            /// The sign of the velocity specified at the "Velocity" parameter defines the direction of rotation.
            VELOCITY_SPECIFIED := INT#0,
            /// Positive direction.
            POSITIVE := INT#1,
            /// Negative direction.
            NEGATIVE := INT#2
        ) := VELOCITY_SPECIFIED;
    END_TYPE
END_NAMESPACE
