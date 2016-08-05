AbstractType(Component/MovementHandler)
	var tmp
		Component/physics/_physics

	proc/Start()
		_physics = GetComponent(/Component/physics)

	proc/Destroy()
		_physics.SetVelocity()
		_physics = null

	proc/GetVelocity()
		return VECTOR2_ZERO

	proc/Update()
		_physics.SetVelocity(GetVelocity())
