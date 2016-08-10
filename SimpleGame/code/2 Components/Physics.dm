Component/physics
	/* Distance covered per second, in pixels.
		Actual movement occurs every tick of the Physics Clock.
		Setter: SetVelocity() (don't set this directly)
	*/
	var
		vector2/velocity
		TranslateFlags/translate_flags = 0

	var tmp
		_is_physics_enabled = FALSE

	var global
		update_loop/update_loop

	update_loop
		parent_type = /update_loop
		callback = "_PhysicsUpdate"

		Update(Updater)
			if(world.tick_usage > 75)
				sleep world.tick_lag
			..()

	/* Set velocity.
		See: PhysicsUpdate()
	*/
	proc
		Start()
			SetVelocity(velocity)

		Destroy()
			SetVelocity()

		SetVelocity(vector2/Velocity)
			if(velocity == Velocity || Velocity && Velocity.Equals(velocity))
				return

			if(Velocity && !Velocity.IsZero())
				velocity = Velocity.Copy()
				if(_is_physics_enabled) return
				_is_physics_enabled = TRUE
				if(!update_loop)
					update_loop = new /Component/physics/update_loop
				update_loop.Add(src)

			else
				velocity = null
				if(_is_physics_enabled)
					_is_physics_enabled = FALSE
					update_loop.Remove(src)
					if(!update_loop.updaters)
						update_loop = null

		/* Called every physics-tick, just before velocity is applied.
		Only called when velocity is non-zero.
		Available for overriding.
		*/
		PhysicsUpdate(update_loop/Time)

		_PhysicsUpdate(update_loop/Time)
			if(!entity.z)
				SetVelocity()

			else
				PhysicsUpdate(Time)

				if(velocity)
					entity.Translate(
						velocity.Multiply(Time.delta_time), translate_flags)
