AbstractType(Component/Weapon/Gun)
	var
		fire_button = MouseButton.Left
		gamepad_fire_button = GamepadButton.R2

		muzzle_speed = 1600
		body_length = 32

		bullet_drag = 1
		bullet_minimum_speed = 100

	var tmp
		cooldown/shot_cooldown = new (1)
		_fire_button_downed
		InputHandler/_input_handler

	Update()
		..()
		if(CanShoot())
			_fire_button_downed = FALSE
			shot_cooldown.Start()
			Shoot()

	Start()
		..()
		_input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		if(_input_handler)
			EVENT_ADD(_input_handler.ButtonPressed, src,
				.proc/HandleButtonPressed)

	Destroy()
		..()
		if(_input_handler)
			EVENT_REMOVE(_input_handler.ButtonPressed, src,
				.proc/HandleButtonPressed)
			_input_handler = null

	proc
		CanShoot()
			if(shot_cooldown && shot_cooldown.IsCoolingDown())
				return FALSE

			if(_fire_button_downed)
				return TRUE

			if(IsTriggerPulled())
				return TRUE

			return FALSE

		IsTriggerPulled()
			if(_input_handler)
				return _input_handler.IsButtonPressed(fire_button) \
					|| _input_handler.IsButtonPressed(gamepad_fire_button)

		HandleButtonPressed(InputHandler/InputHandler, Button)
			if(Button == fire_button || Button == gamepad_fire_button)
				_fire_button_downed = TRUE

		Shoot()
			var
				Entity/bullet/bullet =	ObjectPool.Pop(BulletPool)

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
				* Math.DirectionToRotation(muzzle_velocity.GetNormalized())

			bullet.SetCenter(entity)
			bullet.Translate(to_muzzle)

			return bullet

		GetDirection()
			return _aiming_handler.GetDirection()

		GetMuzzlePosition()
			var vector2/direction = _aiming_handler.GetDirection()
			return new /vector2 (
				direction.GetX() * body_length + entity.GetCenterX(),
				direction.GetY() * body_length + entity.GetCenterY())

		GetMuzzleVelocity()
			var vector2/direction = _aiming_handler.GetDirection()
			return direction.Multiply(muzzle_speed)
