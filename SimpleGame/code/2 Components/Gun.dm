AbstractType(Component/Weapon/Gun)
	var
		fire_button = Macro.MouseLeftButton
		gamepad_fire_button = Macro.GamepadR2

		muzzle_speed = 1600
		body_length = 32

		bullet_drag = 1
		bullet_minimum_speed = 100

	var tmp
		cooldown/shot_cooldown = new (1)
		_fire_button_downed

	Update()
		..()
		if(CanShoot())
			_fire_button_downed = FALSE
			shot_cooldown.Start()
			Shoot()

	Start()
		..()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		if(input_handler)
			EVENT_ADD(input_handler.OnButton, src, .proc/HandleButton)

	Destroy()
		..()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		if(input_handler)
			EVENT_REMOVE(input_handler.OnButton, src, .proc/HandleButton)

	proc/CanShoot()
		if(shot_cooldown && shot_cooldown.IsCoolingDown())
			return FALSE

		if(_fire_button_downed)
			return TRUE

		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		if(input_handler && IsTriggerPulled())
			return TRUE

		return FALSE

	proc/IsTriggerPulled()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		if(input_handler)
			return input_handler.GetButtonState(fire_button) \
				|| input_handler.GetButtonState(gamepad_fire_button)

	proc/HandleButton(
		InputHandler/InputHandler, Macro/Macro, ButtonState/ButtonState)
		if(ButtonState == ButtonState.Pressed \
			&& (Macro == fire_button || Macro == gamepad_fire_button))
			_fire_button_downed = TRUE

	proc/Shoot()
		var
			Entity/bullet/bullet =	ObjectPool.Pop(bullet_pool)

			Component/physics/bullet/bullet_physics = bullet.GetComponent(
				/Component/physics)

			vector2
				muzzle_position = GetMuzzlePosition()
				to_muzzle = muzzle_position.Subtract(entity.GetCenterPosition())
				muzzle_velocity = GetMuzzleVelocity()

		bullet.alpha = 0
		animate(bullet, alpha = 255, time = world.tick_lag)

		bullet_physics.drag = bullet_drag
		bullet_physics.minimum_speed = bullet_minimum_speed
		bullet_physics.initial_speed = muzzle_velocity.GetMagnitude()
		bullet_physics.SetVelocity(muzzle_velocity)

		bullet.transform = initial(bullet.transform) \
			* Math.RotationMatrix(muzzle_velocity.GetNormalized())

		bullet.SetCenter(entity)
		bullet.Translate(to_muzzle)

		return bullet

	proc/GetDirection()
		return _aiming_handler.GetDirection()

	proc/GetMuzzlePosition()
		var vector2/muzzle_position = _aiming_handler.GetDirection()
		muzzle_position.Scale(body_length, Vector2Flags.Modify)
		muzzle_position.Add(entity.GetCenterPosition(), Vector2Flags.Modify)
		return muzzle_position

	proc/GetMuzzleVelocity()
		var vector2/muzzle_velocity = GetDirection()
		muzzle_velocity = muzzle_velocity.Scale(muzzle_speed)
		return muzzle_velocity


	// === Concrete gun types

	inaccurate
		body_length = 40
		var
			inaccuracy = 2

		GetDirection()
			var vector2/direction = ..()
			return direction.Turn(
				pick(1, -1) * inaccuracy * (2 * rand() - 1) ** 2)

		spread
			inaccuracy = 10
			shot_cooldown = new (5)
			body_length = 35

			var
				spread_count = 10
				velocity_max_scale = 0.3

			Shoot()
				var
					Entity/bullet/bullet
					Component/physics/bullet/bullet_physics
					n
					random_velocity_scale

				for(n in 1 to spread_count)
					bullet = ..()
					bullet_physics = bullet.GetComponent(/Component/physics)

					bullet_physics.drag = 2
					bullet_physics.minimum_speed = 300

					random_velocity_scale = 1 - rand() * velocity_max_scale
					if(bullet_physics.velocity)
						bullet_physics.SetVelocity(
							bullet_physics.velocity.Scale(
								random_velocity_scale)
							)
