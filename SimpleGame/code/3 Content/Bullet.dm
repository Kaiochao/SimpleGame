var BulletStatic/Bullet = new

BulletStatic
	var
		ObjectPool/pool

	proc
		GetObjectPool()
			if(!pool)
				pool = new /ObjectPool { name = "Bullet Pool" } (/Bullet, 1000, 100)
			return pool

Bullet
	parent_type = /obj

	mouse_opacity = FALSE

	icon_state = "oval"
	color = "yellow"

	density = TRUE
	bounds = "1,1"
	pixel_x = (1 - 32) / 2
	pixel_y = (1 - 32) / 2
	transform = matrix(3/32, 0, 0, 0, 9/32, 0)

	var
		minimum_speed
		drag

		tmp
			initial_speed

			_minimum_speed_squared
			_old_minimum_speed

	Cross(Bullet/Bullet)
		return istype(Bullet) || ..()

	Translate(vector2/V)
		. = ..()
		var atom/movable/translate_result/result = .
		if(!result || result.bump_dir)
			Pool()

	PhysicsUpdate(UpdateLoop/Time)
		var speed_squared = velocity && velocity.GetSquareMagnitude()

		if(minimum_speed != _old_minimum_speed)
			_old_minimum_speed = minimum_speed
			_minimum_speed_squared = minimum_speed * minimum_speed

		if(speed_squared < _minimum_speed_squared)
			Pool()

		else
			SetVelocity(velocity.Dampen(0, drag, Time.delta_time))

	EVENT(OnPooled, Bullet/Bullet)

	proc
		Pool()
			loc = null
			if(OnPooled)
				OnPooled(src)
