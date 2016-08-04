Weapon
	parent_type = /Component

	var tmp
		obj/body
		mob/equipper

	New(obj/Body)
		if(Body)
			SetBody(Body)

	proc
		Start(mob/Equipper)
			equipper = Equipper
			if(body)
				Equipper.overlays += body

		Destroy(mob/Equipper)
			if(body)
				Equipper.overlays -= body
			equipper = null

		SetBody(obj/Body)
			body = Body

		Update(mob/player/Player, DeltaTime)
			if(body)
				UpdateBodyRotation(Player, DeltaTime)

		UpdateBodyRotation(mob/player/Player, DeltaTime)
			var AimingHandler/player_aiming = Player.aiming_handler
			if(player_aiming)
				var Vector2/aim = player_aiming.GetDirection()
				animate(Player,
					time = world.tick_lag,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW,
					transform = initial(Player.transform) * Math.RotationMatrix(aim)
				)
