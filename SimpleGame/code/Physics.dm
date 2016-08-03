#include "Vector2.dm"
#include "PixelMovement.dm"
#include "UpdateLoop.dm"

var UpdateLoop/Physics/physics_loop = new

UpdateLoop/Physics
	callback = "_PhysicsUpdate"

atom/movable
	/* Distance covered per second, in pixels.
		Actual movement occurs every tick of the Physics Clock.
	*/
	var Vector2/velocity

	New()
		..()
		if(velocity)
			SetVelocity(velocity)

	/* Set velocity.
	*/
	proc/SetVelocity(Vector2/Velocity)
		if(velocity == Velocity || velocity && velocity.Equals(Velocity)) return

		velocity = Velocity

		if(!velocity || velocity.IsZero())
			_DisablePhysics()
		else
			_EnablePhysics()

	/* Called every physics-tick, just before velocity is applied.
		Only called when velocity is non-zero.
		Available for overriding.
	*/
	proc/PhysicsUpdate(UpdateLoop/Physics/PhysicsLoop, DeltaTime)




	var tmp/_physics_enabled = FALSE

	proc/_EnablePhysics()
		if(_physics_enabled) return
		_physics_enabled = TRUE
		physics_loop.Add(src)

	proc/_DisablePhysics()
		if(_physics_enabled)
			_physics_enabled = FALSE
			physics_loop.Remove(src)

	proc/_PhysicsUpdate(UpdateLoop/Physics/PhysicsLoop, DeltaTime)
		if(!z)
			SetVelocity()

		else
			PhysicsUpdate(PhysicsLoop, DeltaTime)

			if(velocity)
				var Vector2/time_velocity = velocity.Multiply(DeltaTime)
				Translate(time_velocity)
