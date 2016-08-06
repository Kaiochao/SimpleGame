var object_pool/particle_pool = new /object_pool {
	push_on_instantiation = TRUE
	} (/Entity/particle, 500, 100)

SealedType(Entity/particle)
	mouse_opacity = FALSE
	
	var tmp
		Component
			physics/physics

		object_pool/_pool

	AddDefaultComponents()
		SetUpdateEnabled(FALSE)
		if(_pool)
			physics = new /Component/physics
			AddComponents(list(
				physics
				))

	/*
		Called when unpooled to reset the particle.
		By default, this resets appearance to its compile-time value and
		re-defaults the component set.
	*/
	proc/Reset()
		appearance = initial(appearance)
		RemoveComponents(_components)
		AddDefaultComponents()

	// === Implement /object_pool/Poolable Interface

	/*
		Returns the object pool that owns this object.
	*/
	proc/GetObjectPool()
		return _pool

	/*
		Called when the particle is added to an object pool.
	*/
	proc/Pooled(object_pool/ObjectPool)
		_pool = ObjectPool
		RemoveComponents(_components)

	/*
		Called when the particle is removed from an object pool.
	*/
	proc/Unpooled(object_pool/ObjectPool)
		Reset()
		SetUpdateEnabled(TRUE)

	/*
		Call this to move the particle to the pool.
		The particle will no longer be on the map or be updating.
	*/
	proc/Pool()
		loc = null
		SetUpdateEnabled(FALSE)
