AbstractType(Component/MovementHandler)
	var tmp
		Component/physics/_physics

	proc
		Start()
			_physics = GetComponent(/Component/physics)

		Destroy()
			_physics.SetVelocity()
			_physics = null

		GetVelocity()
			return VECTOR2_ZERO

		Update()
			_physics.SetVelocity(GetVelocity())
