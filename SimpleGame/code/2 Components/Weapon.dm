AbstractType(Component/Weapon)
	var
		obj/body

	var tmp
		Component/AimingHandler/_aiming_handler

		vector2/_last_aim

	New(obj/Body)
		if(Body)
			SetBody(Body)

	proc
		Start()
			if(body)
				entity.underlays += body

			_aiming_handler = entity.GetComponent(/Component/AimingHandler)

		Destroy()
			if(body)
				entity.underlays -= body

			_aiming_handler = null

		SetBody(obj/Body)
			body = Body

		Update()
			if(body)
				UpdateBodyRotation()

		UpdateBodyRotation()
			if(_aiming_handler)
				var vector2/aim = _aiming_handler.GetDirection()
				if(aim.Equals(_last_aim)) return
				_last_aim = aim
				animate(entity,
					time = world.tick_lag,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW,
					transform = initial(entity.transform) * Math.DirectionToRotation(aim)
				)
