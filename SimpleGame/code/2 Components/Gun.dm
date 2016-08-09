AbstractType(Component/Weapon/Gun)
	var
		muzzle_speed = 1600
		body_length = 32

		bullet_drag = 1
		bullet_minimum_speed = 100

	var tmp
		cooldown/shot_cooldown = new (1)
		Component/WeaponHandler/_weapon_handler
		_used

	Update()
		..()
		if(CanShoot())
			_used = FALSE
			if(shot_cooldown)
				shot_cooldown.Start()
			Shoot()

	Start()
		..()
		_weapon_handler = GetComponent(/Component/WeaponHandler)
		EVENT_ADD(_weapon_handler.StartedUsing, src, .proc/HandleStartedUsing)

	Destroy()
		..()
		if(_weapon_handler)
			EVENT_REMOVE_OBJECT(_weapon_handler.StartedUsing, src)

	proc
		HandleStartedUsing()
			_used = TRUE

		CanShoot()
			return _used \
			|| _weapon_handler.IsUsing() \
				&& !(shot_cooldown && shot_cooldown.IsCoolingDown())

		/* Launches a bullet.
		 	Starts from the shooter's center, but moves immediately to GetMuzzlePosition().
			Initial velocity given by GetMuzzleVelocity().

			Returns the bullet launched, or a list of bullets launched.
		*/
		Shoot()
			var
				Entity/bullet/bullet =	ObjectPool.Pop(BulletPool)

				Component/physics/bullet/bullet_physics = bullet.GetComponent(/Component/physics)

				vector2
					muzzle_position = GetMuzzlePosition()
					to_muzzle = muzzle_position.Subtract(entity.GetCenterPosition())
					muzzle_velocity = GetMuzzleVelocity()

			// bullet.alpha = 0
			// animate(bullet, alpha = 255, time = world.tick_lag)

			bullet_physics.drag = bullet_drag
			bullet_physics.minimum_speed = bullet_minimum_speed
			bullet_physics.initial_speed = muzzle_velocity.GetMagnitude()
			bullet_physics.SetVelocity(muzzle_velocity)

			bullet.transform = initial(bullet.transform) \
				* Math.DirectionToRotation(muzzle_velocity.GetNormalized())

			bullet.SetCenter(entity)
			bullet.Translate(to_muzzle)

			return bullet

		GetMuzzlePosition()
			var vector2/direction = _aiming_handler.GetDirection()
			return new /vector2 (
				direction.GetX() * body_length + entity.GetCenterX(),
				direction.GetY() * body_length + entity.GetCenterY())

		GetMuzzleVelocity()
			var vector2/direction = _aiming_handler.GetDirection()
			return direction.Multiply(muzzle_speed)
