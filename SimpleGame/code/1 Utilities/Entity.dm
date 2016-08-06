var update_loop/ComponentLoop

AbstractType(Entity)
	parent_type = /obj

	var tmp
		/*
			Set of components added to this entity.
		*/
		_components[]

		/*
			Subset of components; components with an Update callback.
		*/
		_component_updaters[]

		/*
			Subset of components; components with a Destroy callback.
		*/
		_component_destroyers[]

		/*
			Prevents multiple destruction of the same entity.
		*/
		_is_destroyed

		/*
			Property for IsUpdating() and SetUpdateEnabled(Value)
		*/
		_is_update_enabled

	EVENT(OnUpdate)
	EVENT(OnDestroy)

	New()
		..()
		AddDefaultComponents()
		if(isnull(_is_update_enabled))
			SetUpdateEnabled(TRUE)

	Del()
		RemoveComponents(_components)
		SetUpdateEnabled(FALSE)
		..()

	proc/Destroy()
		// Can't Destroy more than once.
		if(_is_destroyed) return

		// Stop updating.
		SetUpdateEnabled(FALSE)

		// Remove all components.
		RemoveComponents(_components)

		// Fire event.
		if(OnDestroy)
			OnDestroy()

		SetLocation()

		// Prevent excess destruction.
		_is_destroyed = TRUE


	// ====== Components!

	/*

		Override this in sub-types of Entity to add the components that it
		should start out with.

	*/
	proc/AddDefaultComponents()

	proc/GetComponent(ComponentType)
		return locate(ComponentType) in _components

	/*

		Add a single component to this Entity.
		* If Component has Start defined, it will be called after being added.
		* If Component has Update defined, it will be called every update as
		long as Entity.IsUpdateEnabled() is TRUE.

	*/
	proc/AddComponent(Component/Component)
		AddComponents(list(Component))

	/*



	*/
	proc/RemoveComponent(Component/Component)
		RemoveComponents(list(Component))

	/*

		Add a bunch of components at once.

		This is preferred to adding components separately with AddComponent().
		Component.Start() is called AFTER everything is added, which allows for
		dependence between components.

		Basically, using X = GetComponent() in Component.Start() will work as
		long as X was added before or at the same time as Component.

		(But X.Start() may not have been called yet.)

	*/
	proc/AddComponents(Components[])
		if(!length(Components)) return

		if(!_components)
			_components = new

		var
			item
			Component
				component
				Starter/starter

		for(item in Components)
			component = item
			component.entity = src
			component.GetName()

			component.Time = ComponentLoop

			if(!_components[component])
				_components[component] = TRUE

			if(hascall(component, "Update"))
				if(!_component_updaters)
					_component_updaters = new
				_component_updaters[component] = TRUE
				EVENT_ADD(OnUpdate, component, "Update")

				SetUpdateEnabled(IsUpdateEnabled())

			if(hascall(component, "Destroy"))
				if(!_component_destroyers)
					_component_destroyers = new
				_component_destroyers[component] = TRUE
				EVENT_ADD(OnDestroy, component, "Destroy")

		for(item in Components)
			if(hascall(item, "Start"))
				starter = item
				starter.Start(src)

	/*

		Remove a bunch of components at once.

		Similar to AddComponents(), this calls Component.Destroy()
		BEFORE anything is actually removed.

	*/
	proc/RemoveComponents(Components[])
		if(!length(Components)) return

		var global
			item
			Component
				component
				Destroyer/destroyer

		for(item in Components)
			if(_component_destroyers && _component_destroyers[item])
				destroyer = item

				_component_destroyers -= destroyer
				if(!length(_component_destroyers))
					_component_destroyers = null

				EVENT_REMOVE(OnDestroy, destroyer, "Destroy")

				destroyer.Destroy()

		for(item in Components)
			component = item

			_components -= component
			if(!length(_components))
				_components = null

			if(_component_updaters && _component_updaters[component])
				_component_updaters -= component
				if(!length(_component_updaters))
					_component_updaters = null
				EVENT_REMOVE(OnUpdate, component, "Update")

				SetUpdateEnabled(IsUpdateEnabled())

			component.entity = null
			component.Time = null

	// === Updating components!

	proc/IsUpdateEnabled()
		return _is_update_enabled

	proc/SetUpdateEnabled(Value)
		_is_update_enabled = Value
		if(Value)
			if(length(_component_updaters))
				if(!ComponentLoop)
					ComponentLoop = new /update_loop ("Update")
				ComponentLoop.Add(src)
		else
			if(ComponentLoop)
				ComponentLoop.Remove(src)
				if(!ComponentLoop.updaters)
					ComponentLoop = null

	proc/Update()
		if(OnUpdate)
			OnUpdate()
