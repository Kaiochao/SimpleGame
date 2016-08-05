AbstractType(MovementHandler)
	parent_type = /Component

	var tmp
		Physics/_physics

	proc/Start()
		_physics = GetComponent(/Physics)

	proc/Destroy()
		_physics.SetVelocity()
		_physics = null

	proc/GetVelocity()
		return VECTOR2_ZERO

	proc/Update()
		_physics.SetVelocity(GetVelocity())
