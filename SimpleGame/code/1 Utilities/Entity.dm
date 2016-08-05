AbstractType(Entity)
	parent_type = /obj

	var global
		// If no mobs exist, does this reference prevent garbage collection?
		update_loop/_component_update_loop

	var tmp
		_components[]
		_component_updaters[]
		_component_destroyers[]

		_is_destroyed = FALSE

		_enabled = TRUE

	New()
		..()
		AddDefaultComponents()

		if(IsUpdateEnabled())
			_enabled = FALSE
			EnableUpdate()

	Del()
		DisableUpdate()
		..()

	EVENT(OnUpdate)
	EVENT(OnDestroy)

	proc/IsUpdateEnabled()
		return _enabled

	proc/EnableUpdate()
		if(_enabled) return
		_enabled = TRUE
		_component_update_loop = GetComponentUpdateLoop()
		_component_update_loop.Add(src)

	proc/DisableUpdate()
		if(!_enabled) return
		_enabled = FALSE
		_component_update_loop.Remove(src)
		if(!_component_update_loop.updaters)
			_component_update_loop = null

	proc/AddDefaultComponents()

	proc/GetComponentUpdateLoop()
		if(!_component_update_loop)
			_component_update_loop = new ("Update")
		return _component_update_loop

	proc/Update()
		if(OnUpdate)
			OnUpdate()

	proc/Destroy()
		// Can't Destroy more than once.
		if(_is_destroyed) return

		// Stop updating.
		DisableUpdate()

		// Remove all components.
		RemoveComponents(_components)

		// Fire event.
		if(OnDestroy)
			OnDestroy()

		// Prevent excess destruction.
		_is_destroyed = TRUE

	// ====== Components!

	proc/GetComponent(ComponentType)
		return locate(ComponentType) in _components

	proc/HasComponent(Component)
		return ispath(Component) \
		? !!GetComponent(Component) \
		: _components && _components[Component]

	proc/AddComponent(Component/Component)
		AddComponents(list(Component))

	/*

		Add a bunch of components at once.

		This is preferred to adding components separately with AddComponent()
		because Component.Start() is called AFTER everything is added.

	*/
	proc/AddComponents(Components[])
		if(!_components)
			_components = new

		var global
			item
			Component
				component
				Starter/starter

		for(item in Components)
			component = item
			component.entity = src
			component.Time = GetComponentUpdateLoop()

			if(!_components[component])
				_components[component] = TRUE

			if(hascall(component, "Update"))
				if(!_component_updaters)
					_component_updaters = new
				_component_updaters[component] = TRUE
				EVENT_ADD(OnUpdate, component, "Update")

			if(hascall(component, "Destroy"))
				if(!_component_destroyers)
					_component_destroyers = new
				_component_destroyers[component] = TRUE
				EVENT_ADD(OnDestroy, component, "Destroy")

		for(item in Components)
			if(hascall(item, "Start"))
				starter = item
				starter.Start(src)

	proc/RemoveComponent(Component/Component)
		RemoveComponents(list(Component))

	/*

		Remove a bunch of components at once.

		Similar to AddComponents(), this calls Component.Destroy()
		BEFORE anything is actually removed.

	*/
	proc/RemoveComponents(Components[])
		var global
			item
			Component
				component
				Destroyer/destroyer

		for(item in Components)
			if(_component_destroyers && _component_destroyers[item])
				destroyer = item

				_component_destroyers -= destroyer
				if(!_component_destroyers.len)
					_component_destroyers = null

				EVENT_REMOVE(OnDestroy, destroyer, "Destroy")

				destroyer.Destroy()

		for(item in Components)
			component = item

			_components -= component
			if(!_components.len)
				_components = null

			if(_component_updaters && _component_updaters[component])
				_component_updaters -= component
				if(!_component_updaters.len)
					_component_updaters = null
				EVENT_REMOVE(OnUpdate, component, "Update")

			component.entity = null
			component.Time = null
