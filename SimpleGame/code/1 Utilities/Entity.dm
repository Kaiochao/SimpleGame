var update_loop/component/ComponentUpdateLoop

update_loop/component
	UpdateUpdaters()
		var item, Entity/entity
		for(item in updaters)
			entity = item
			entity.UpdateComponents()
		for(item in updaters)
			entity = item
			entity.LateUpdateComponents()

AbstractType(Entity)
	parent_type = /obj

	var tmp
		/* Set of components added to this entity.
		*/
		_components[]

		/* Subset of components: components with Update defined.
		*/
		_updatable_components[]

		/* Subset of components: components with LateUpdate defined.
		*/
		_late_updatable_components[]

		/* Subset of components: components with Destroy defined.
		*/
		_destroyable_components[]

		/* Prevents multiple destruction of the same entity.
		*/
		_is_destroyed

		/* Property for IsUpdating() and SetUpdateEnabled(Value)
		*/
		_is_update_enabled

	EVENT(Updated, Entity/Entity)
	EVENT(LateUpdated, Entity/Entity)
	EVENT(Destroyed, Entity/Entity)

	New()
		..()
		AddDefaultComponents()
		if(isnull(_is_update_enabled))
			SetUpdateEnabled(TRUE)

	Del()
		RemoveComponents(_components)
		SetUpdateEnabled(FALSE)
		..()

	proc
		Destroy()
			// Can't Destroy more than once.
			if(_is_destroyed) return

			// Stop updating.
			SetUpdateEnabled(FALSE)

			// Remove all components.
			RemoveComponents(_components)

			// Destroy destroyable components and fire destruction event.
			DestroyAllComponents()
			Destroyed()

			SetLocation()

			// Prevent excess destruction.
			_is_destroyed = TRUE

		// ====== Components!

		DestroyAllComponents()
			if(length(_destroyable_components))
				var item, Component/Destroyable/destroyable
				for(item in _destroyable_components)
					destroyable = item
					destroyable.Destroy()

		/* Called when this Entity is initialized. Meant for overriding.

		Override this in sub-types of Entity to add the components that it
		should start out with.

		*/
		AddDefaultComponents()

		/* Returns a component of type ComponentType added to this Entity.
		*/
		GetComponent(ComponentType)
			return locate(ComponentType) in _components

		/* Add a single component to this Entity.

		If Component has Start defined, it will be called after being added.

		If Component has Update defined, it will be called every update as
		long as Entity.IsUpdateEnabled() is TRUE.

		*/
		AddComponent(Component/Component)
			AddComponents(list(Component))

		/* Remove a single component from this Entity.

		If Component has Destroy defined, it is called before being removed.

		*/
		RemoveComponent(Component/Component)
			RemoveComponents(list(Component))

		/* Add a bunch of components at once.

		This is preferred to adding components separately with AddComponent().
		Component.Start() is called AFTER everything is added, which allows for
		dependence between components.

		Basically, using X = GetComponent() in Component.Start() will work as
		long as X was added before or at the same time as Component.

		(But X.Start() may not have been called yet.)

		*/
		AddComponents(Components[])
			if(!length(Components)) return

			if(!_components)
				_components = new

			var
				item
				Component
					component
					Startable/startable

			for(item in Components)
				component = item
				component.entity = src
				component.GetName()

				component.Time = ComponentUpdateLoop

				if(!_components[component])
					_components[component] = TRUE

				if(hascall(component, "Update"))
					if(!_updatable_components)
						_updatable_components = new
					_updatable_components[component] = TRUE

				if(hascall(component, "LateUpdate"))
					if(!_late_updatable_components)
						_late_updatable_components = new
					_late_updatable_components[component] = TRUE

				if(hascall(component, "Destroy"))
					if(!_destroyable_components)
						_destroyable_components = new
					_destroyable_components[component] = TRUE

			for(item in Components)
				if(hascall(item, "Start"))
					startable = item
					startable.Start(src)

			_CheckUpdates()

		/* Remove a bunch of components at once.

		Similar to AddComponents(), this calls all Component.Destroy()'s
		(if any) BEFORE anything is actually removed.

		*/
		RemoveComponents(Components[])
			if(!length(Components)) return

			var
				item
				Component
					component
					Destroyable/destroyable

			for(item in Components)
				// This line not only calls Destroy only if the call exists;
				// it also prevents multiple calls to Destroy.
				if(_destroyable_components && _destroyable_components[item])
					destroyable = item
					_destroyable_components -= destroyable
					if(!length(_destroyable_components))
						_destroyable_components = null
					destroyable.Destroy()

			for(item in Components)
				component = item

				_components -= component
				if(!length(_components))
					_components = null

				if(_updatable_components && _updatable_components[component])
					_updatable_components -= component
					if(!length(_updatable_components))
						_updatable_components = null

				if(_late_updatable_components \
					&& _late_updatable_components[component])
					_late_updatable_components -= component
					if(!length(_late_updatable_components))
						_late_updatable_components = null

				component.entity = null
				component.Time = null

			_CheckUpdates()

		// === Updating components!

		/* Is this Entity enabled for updates?

		If so, and the Entity has an updatable component, then
		Entity.UpdateComponents() is called every tick of the ComponentUpdateLoop,
		which calls Component.Update() for all components that have it.
		*/
		IsUpdateEnabled()
			return _is_update_enabled

		/* Enable or disable this Entity for updates.
		*/
		SetUpdateEnabled(Value)
			_is_update_enabled = Value
			_CheckUpdates()

		/* Add or remove this Entity from the ComponentUpdateLoop when appropriate.
		*/
		_CheckUpdates()
			if(IsUpdateEnabled())
				if(length(_updatable_components) \
				|| length(_late_updatable_components))
					if(!ComponentUpdateLoop)
						ComponentUpdateLoop = new /update_loop/component
					ComponentUpdateLoop.Add(src)
			else
				if(ComponentUpdateLoop)
					ComponentUpdateLoop.Remove(src)
					if(!ComponentUpdateLoop.updaters)
						ComponentUpdateLoop = null

		/* Called periodically when this Entity has an updatable component.
		*/
		UpdateComponents()
			var item, Component/Updatable/updatable

			for(item in _updatable_components)
				updatable = item
				updatable.Update()

			Updated()

		/* Called periodically, but not before any UpdateComponents() calls. 
		*/
		LateUpdateComponents()
			var item, Component/LateUpdatable/late_updatable

			for(item in _late_updatable_components)
				late_updatable = item
				late_updatable.LateUpdate()

			LateUpdated()
