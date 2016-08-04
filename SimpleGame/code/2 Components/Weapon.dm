AbstractType(Weapon)
	parent_type = /Component

	var tmp
		obj/body

		AimingHandler/_aiming_handler

	New(obj/Body)
		if(Body)
			SetBody(Body)

	proc
		Start()
			if(body)
				player.underlays += body

			_aiming_handler = player.GetComponent(/AimingHandler)

		Destroy()
			if(body)
				player.underlays -= body

			_aiming_handler = null

		SetBody(obj/Body)
			body = Body

		Update()
			if(body)
				UpdateBodyRotation()

		UpdateBodyRotation()
			if(_aiming_handler)
				var vector2/aim = _aiming_handler.GetDirection()
				animate(player,
					time = world.tick_lag,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW,
					transform = initial(player.transform) * Math.RotationMatrix(aim)
				)
