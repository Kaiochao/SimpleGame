var update_loop/physics_loop = new ("_PhysicsUpdate")

Component/physics
	/* Distance covered per second, in pixels.
		Actual movement occurs every tick of the Physics Clock.
		Setter: SetVelocity() (don't set this directly)
	*/
	var
		vector2/velocity
		TranslateFlags/translate_flags = 0

	New()
		..()
		if(velocity)
			SetVelocity(velocity)

	/* Set velocity.
		See: PhysicsUpdate()
	*/
	proc/SetVelocity(vector2/Velocity)
		if(velocity == Velocity || Velocity && Velocity.Equals(velocity))
			return

		if(Velocity && !Velocity.IsZero())
			velocity = Velocity.Copy()
			_EnablePhysics()
		else
			velocity = null
			_DisablePhysics()

	/* Called every physics-tick, just before velocity is applied.
		Only called when velocity is non-zero.
		Available for overriding.
	*/
	proc/PhysicsUpdate(update_loop/Time)




	var tmp/_physics_enabled = FALSE

	proc/_EnablePhysics()
		if(_physics_enabled) return
		_physics_enabled = TRUE
		physics_loop.Add(src)

	proc/_DisablePhysics()
		if(_physics_enabled)
			_physics_enabled = FALSE
			physics_loop.Remove(src)

	proc/_PhysicsUpdate(update_loop/Time)
		if(!entity.z)
			SetVelocity()

		else
			PhysicsUpdate(Time)

			if(velocity)
				entity.Translate(velocity.Multiply(Time.delta_time), translate_flags)
