#include "Vector2.dm"

MovementHandler
	parent_type = /Component

	proc
		GetVelocity()
			return VECTOR2_ZERO

		Update(atom/movable/Mover, DeltaTime)
			Mover.SetVelocity(GetVelocity())
