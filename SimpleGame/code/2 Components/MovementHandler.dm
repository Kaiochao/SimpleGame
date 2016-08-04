AbstractType(MovementHandler)

	parent_type = /Component

	proc
		GetVelocity()
			return VECTOR2_ZERO

		Update()
			player.SetVelocity(GetVelocity())

		Destroy()
			player.SetLocation()
			player.SetVelocity()
