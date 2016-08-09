Component/Weapon/Gun
	inaccurate
		body_length = 40
		var
			inaccuracy = 2

		GetMuzzleVelocity()
			var vector2/velocity = ..()
			return velocity.Turn(pick(1, -1) * inaccuracy * (2 * rand() - 1) ** 2)

		GetOwnName()
			return "inaccurate automatic gun"

	inaccurate/spread
		inaccuracy = 10
		shot_cooldown = new (5)
		body_length = 35

		var
			spread_count = 5
			velocity_max_scale = 0.3

		GetOwnName()
			return "spread shot gun"

		Shoot()
			var
				Entity/bullet/bullet
				Component/physics/bullet/bullet_physics
				n
				random_velocity_scale
				bullets[spread_count]

			for(n in 1 to spread_count)
				bullets[n] = bullet = ..()

				bullet_physics = bullet.GetComponent(/Component/physics)

				bullet_physics.drag = 2
				bullet_physics.minimum_speed = 300

				random_velocity_scale = 1 - rand() * velocity_max_scale
				if(bullet_physics.velocity)
					bullet_physics.SetVelocity(
						bullet_physics.velocity.Scale(random_velocity_scale)
						)

			return bullets
