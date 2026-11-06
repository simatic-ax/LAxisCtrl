NAMESPACE Simatic.Ax.LAxisCtrl
    TYPE
        /// Direction of a modulo axis for positioning or homing operations.
        DirectionModulo : INT (
            /// Axis moves in a positive direction.
            POSITIVE := INT#1,
            /// Axis moves in a negative direction.
            NEGATIVE := INT#2,
            /// Axis moves by shortest distance to target.
            SHORTEST_DISTANCE := INT#3
        ) := POSITIVE;
    END_TYPE
END_NAMESPACE
