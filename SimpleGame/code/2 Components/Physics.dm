var update_loop/physics_loop/physics_loop = new ("_PhysicsUpdate")

update_loop/physics_loop
	Update(Updater)
		if(world.tick_usage > 75)
			sleep world.tick_lag
		..()

Component/physics
	/* Distance covered per second, in pixels.
		Actual movement occurs every tick of the Physics Clock.
		Setter: SetVelocity() (don't set this directly)
	*/
	var
		vector2/velocity
		TranslateFlags/translate_flags = 0

	var tmp/_is_physics_enabled = FALSE

	New()
		..()
		SetVelocity(velocity)

	/* Set velocity.
		See: PhysicsUpdate()
	*/
	proc/SetVelocity(vector2/Velocity)
		if(velocity == Velocity || Velocity && Velocity.Equals(velocity))
			return

		if(Velocity && !Velocity.IsZero())
			velocity = Velocity.Copy()
			if(_is_physics_enabled) return
			_is_physics_enabled = TRUE
			physics_loop.Add(src)

		else
			velocity = null
			if(_is_physics_enabled)
				_is_physics_enabled = FALSE
				physics_loop.Remove(src)

	/* Called every physics-tick, just before velocity is applied.
		Only called when velocity is non-zero.
		Available for overriding.
	*/
	proc/PhysicsUpdate(update_loop/Time)

	proc/_PhysicsUpdate(update_loop/Time)
		if(!entity.z)
			SetVelocity()

		else
			PhysicsUpdate(Time)

			if(velocity)
				entity.Translate(velocity.Multiply(Time.delta_time), translate_flags)
