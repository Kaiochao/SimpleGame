var object_pool/ParticlePool = new /object_pool {
	push_on_instantiation = TRUE
	} (/Entity/particle, 500, 100)

SealedType(Entity/particle)
	mouse_opacity = FALSE

	var tmp
		object_pool/_pool

	AddDefaultComponents()
		SetUpdateEnabled(FALSE)

	/* Called when unpooled to reset the particle.
	By default, this resets appearance to its compile-time value and
	re-defaults the component set.
	*/
	proc
		Reset()
			appearance = initial(appearance)
			RemoveComponents(_components)
			AddDefaultComponents()

		// === Implement /object_pool/Poolable Interface

		/* Returns the object pool that owns this object.
		*/
		GetObjectPool()
			return _pool

		/* Called when the particle is added to an object pool.
		*/
		Pooled(object_pool/ObjectPool)
			_pool = ObjectPool
			RemoveComponents(_components)

		/* Called when the particle is removed from an object pool.
		*/
		Unpooled(object_pool/ObjectPool)
			Reset()
			SetUpdateEnabled(TRUE)

		/* Call this to move the particle to the pool.
		The particle will no longer be on the map or be updating.
		*/
		Pool()
			loc = null
			SetUpdateEnabled(FALSE)
