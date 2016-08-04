AbstractType(Gun)

	parent_type = /Weapon

	var
		fire_button = Macro.MouseLeftButton
		gamepad_fire_button = Macro.GamepadR2

		muzzle_speed = 1600
		body_length = 32

		bullet_drag = 1
		bullet_minimum_speed = 100

		tmp
			Cooldown/shot_cooldown = new (1)
			_fire_button_downed

	Update()
		..()
		if(CanShoot())
			_fire_button_downed = FALSE
			shot_cooldown.Start()
			Shoot()

	Start()
		..()
		EVENT_ADD(player.input_handler.OnButton, src, .proc/HandleButton)

	Destroy()
		..()
		EVENT_REMOVE(player.input_handler.OnButton, src, .proc/HandleButton)

	proc
		CanShoot()
			if(shot_cooldown && shot_cooldown.IsCoolingDown())
				return FALSE

			if(_fire_button_downed)
				return TRUE

			if(player.input_handler && GetFireInputState())
				return TRUE

			return FALSE

		GetFireInputState()
			var InputHandler/input_handler = player.input_handler
			return input_handler.GetButtonState(fire_button) || input_handler.GetButtonState(gamepad_fire_button)

		HandleButton(InputHandler/InputHandler, Macro/Macro, ButtonState/ButtonState)
			if(ButtonState == ButtonState.Pressed && (Macro == fire_button || Macro == gamepad_fire_button))
				_fire_button_downed = TRUE

		Shoot()
			var ObjectPool/bullet_pool = global.Bullet.GetObjectPool()
			var Bullet/bullet = bullet_pool.Pop()

			bullet.alpha = 0
			animate(bullet, alpha = 255, time = world.tick_lag)

			bullet.drag = bullet_drag
			bullet.minimum_speed = bullet_minimum_speed

			var
				vector2
					muzzle_position = GetMuzzlePosition()
					player_position = player.GetCenterPosition()
					to_muzzle = muzzle_position.Subtract(player_position)
					muzzle_velocity = GetMuzzleVelocity()

			bullet.transform = initial(bullet.transform) * Math.RotationMatrix(muzzle_velocity.GetNormalized())
			bullet.initial_speed = muzzle_velocity.GetMagnitude()

			bullet.SetCenter(player)
			bullet.Translate(to_muzzle)

			bullet.SetVelocity(muzzle_velocity)

			return bullet

		GetDirection()
			return _aiming_handler.GetDirection()

		GetMuzzlePosition()
			var vector2/muzzle_position = _aiming_handler.GetDirection()
			muzzle_position.Scale(body_length, Vector2Flags.Modify)
			muzzle_position.Add(player.GetCenterPosition(), Vector2Flags.Modify)
			return muzzle_position

		GetMuzzleVelocity()
			var vector2/muzzle_velocity = GetDirection()
			muzzle_velocity = muzzle_velocity.Scale(muzzle_speed)
			return muzzle_velocity

Gun/inaccurate
	var
		inaccuracy = 2

	GetDirection()
		var vector2/direction = ..()
		return direction.Turn(pick(1, -1) * inaccuracy * (2 * rand() - 1) ** 2)

Gun/spread
	parent_type = /Gun/inaccurate

	inaccuracy = 10
	shot_cooldown = new (5)

	var
		spread_count = 8
		velocity_max_scale = 0.3

	Shoot()
		var Bullet/bullet, n, random_velocity_scale
		for(n in 1 to spread_count)
			bullet = ..()

			bullet.drag = 2
			bullet.minimum_speed = 300

			random_velocity_scale = 1 - rand() * velocity_max_scale
			bullet.SetVelocity(bullet.velocity.Scale(random_velocity_scale))
