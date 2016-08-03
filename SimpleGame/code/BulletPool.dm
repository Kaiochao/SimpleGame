BulletPool
	var
		bullet_type
		initial_count

	var tmp
		Bullet/bullets[]

	New(InitialCount, BulletType = /Bullet)
		if(BulletType)
			bullet_type = BulletType

		if(InitialCount)
			initial_count = InitialCount

		bullets = new (initial_count)

		for(var/n in 1 to bullets.len)
			var Bullet/bullet = new bullet_type
			bullets[n] = bullet
			EVENT_ADD(bullet.OnDestroyed, src, .proc/Push)

	proc
		Pop()
			if(!bullets.len)
				var Bullet
					more_bullets[] = new (initial_count)
					bullet
				for(var/n in 1 to more_bullets.len)
					bullet = new bullet_type
					more_bullets[n] = bullet
					EVENT_ADD(bullet.OnDestroyed, src, .proc/Push)
				bullets += more_bullets

			. = bullets[bullets.len]
			bullets.len--

		Push(Bullet)
			bullets += Bullet
