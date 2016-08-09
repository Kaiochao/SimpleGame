var object_pool/BulletPool = new /object_pool (
	/Entity/bullet, 500, 100)

Component/physics/bullet
	var
		minimum_speed
		drag

	var tmp
		initial_speed

		_minimum_speed_squared
		_old_minimum_speed

	GetOwnName()
		return "bullet physics"

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
		SetUpdateEnabled(FALSE)
		AddComponents(newlist(
			/Component/physics/bullet
			))

	Cross(Entity/bullet/Bullet)
		return istype(Bullet) || ..()

	Translate(vector2/V)
		. = ..()
		var atom/movable/translate_result/result = .
		if(result && result.bump_dir)
			var Entity/particle/smoke = ObjectPool.Pop(ParticlePool)
			smoke.AddComponent(new /Component/ParticleEffector/smoke)
			smoke.SetCenter(src)
			Pool()

	proc
		GetObjectPool()
			return BulletPool

		Unpooled(object_pool/ObjectPool)
			SetUpdateEnabled(TRUE)

		Pooled(object_pool/ObjectPool)
			SetUpdateEnabled(FALSE)

			var Component/physics/physics = GetComponent(/Component/physics)
			physics.SetVelocity()
			loc = null

		Pool()
			if(!ObjectPool.Push(GetObjectPool(), src))
				Pooled()
