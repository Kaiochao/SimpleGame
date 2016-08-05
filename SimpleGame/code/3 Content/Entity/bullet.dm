var BulletStatic/Bullet = new

BulletStatic
	var global
		object_pool/pool

	proc
		GetObjectPool()
			if(!pool)
				pool = new /object_pool {
					name = "bullet pool"
				} (/Entity/bullet, 1000, 100)
			return pool

Physics/bullet
	var
		minimum_speed
		drag

	var tmp
		initial_speed

		_minimum_speed_squared
		_old_minimum_speed

	PhysicsUpdate(update_loop/Time)
		var
			Entity/bullet/bullet = entity
			speed_squared = velocity && velocity.GetSquareMagnitude()

		if(minimum_speed != _old_minimum_speed)
			_old_minimum_speed = minimum_speed
			_minimum_speed_squared = _old_minimum_speed * _old_minimum_speed

		if(speed_squared < _minimum_speed_squared)
			bullet.Pool()

		else
			SetVelocity(velocity.Dampen(0, drag, Time.delta_time))

Entity/bullet
	mouse_opacity = FALSE

	icon_state = "oval"
	color = "yellow"

	density = TRUE
	bounds = "1,1"
	pixel_x = (1 - 32) / 2
	pixel_y = (1 - 32) / 2
	transform = matrix(3/32, 0, 0, 0, 9/32, 0)

	AddDefaultComponents()
		DisableUpdate()
		AddComponents(newlist(
			/Physics/bullet
			))

	Cross(Entity/bullet/Bullet)
		return istype(Bullet) || ..()

	Translate(vector2/V)
		. = ..()
		var atom/movable/translate_result/result = .
		if(!result || result.bump_dir)
			Pool()

	EVENT(OnPooled, object_pool/Poolable/Object)
	EVENT(OnUnpooled, object_pool/Poolable/Object)

	OnUnpooled()
		EnableUpdate()
		..()

	proc/Pool()
		DisableUpdate()

		var Physics/physics = GetComponent(/Physics)
		physics.SetVelocity()

		loc = null

		if(OnPooled)
			OnPooled(src)
