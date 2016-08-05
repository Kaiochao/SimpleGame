mob/player
	icon = null

	bounds = "24,24"
	pixel_x = (24 - 32) / 2
	pixel_y = (24 - 32) / 2

	translate_flags = TranslateFlags.EnableSliding

	var
		global
			// If no mobs exist, does this reference prevent garbage collection?
			UpdateLoop/_component_update_loop

		tmp
			InputHandler/input_handler

			_components[]
			_component_updaters[]
			_component_destroyers[]

			_is_destroyed = FALSE

			_is_updater

	New()
		..()
		_InitializeAppearance()

		_is_updater = hascall(src, "Update")
		if(_is_updater)
			_AddUpdater(src)

	Del()
		if(_is_updater)
			_RemoveUpdater(src)
		..()

	Logout()
		Destroy()
		..()

	EVENT(OnUpdate)
	EVENT(OnDestroy)

	proc
		_InitializeAppearance()
			overlays = list(/obj/player_body)

			/obj/player_body
				icon_state = "oval"
				color = "blue"
				transform = matrix(24/32, 0, 0, 0, 24/32, 0)

		_AddUpdater(Updater)
			_component_update_loop = GetComponentUpdateLoop()
			_component_update_loop.Add(Updater)

		_RemoveUpdater(Updater)
			_component_update_loop.Remove(Updater)
			if(!_component_update_loop.updaters)
				_component_update_loop = null

		GetComponentUpdateLoop()
			if(!_component_update_loop)
				_component_update_loop = new ("Update")
			return _component_update_loop

		Update()
			if(OnUpdate)
				OnUpdate()

		Destroy()
			// Can't Destroy more than once.
			if(_is_destroyed) return

			// Clear the mob's key; otherwise, garbage collection is prevented.
			key = null

			// Stop updating.
			_RemoveUpdater(src)
			_is_updater = FALSE

			// Remove all components.
			RemoveComponents(_components)

			// Fire event.
			if(OnDestroy)
				OnDestroy()

			// Prevent excess destruction.
			_is_destroyed = TRUE

		// ====== Components!

		GetComponent(ComponentType)
			return locate(ComponentType) in _components

		HasComponent(Component)
			return ispath(Component) ? !!GetComponent(Component) : _components && _components[Component]

		AddComponent(Component/Component)
			AddComponents(list(Component))

		/*

			Add a bunch of components at once.

			This is preferred to adding components separately with AddComponent()
			because Component.Start() is called AFTER everything is added.

		*/
		AddComponents(Components[])
			if(!_components)
				_components = new

			var global
				item
				Component
					component
					Starter/starter

			for(item in Components)
				component = item
				component.player = src
				component.Time = GetComponentUpdateLoop()

				if(!_components[component])
					_components[component] = TRUE

				if(hascall(component, "Update"))
					if(!_component_updaters)
						_component_updaters = new
					_component_updaters[component] = TRUE
					_AddUpdater(component)

				if(hascall(component, "Destroy"))
					if(!_component_destroyers)
						_component_destroyers = new
					_component_destroyers[component] = TRUE
					EVENT_ADD(OnDestroy, component, "Destroy")

			for(item in Components)
				if(hascall(item, "Start"))
					starter = item
					starter.Start(src)

		RemoveComponent(Component/Component)
			RemoveComponents(list(Component))

		/*

			Remove a bunch of components at once.

			Similar to AddComponents(), this calls Component.Destroy()
			BEFORE anything is actually removed.

		*/
		RemoveComponents(Components[])
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
					_RemoveUpdater(component)

				component.player = null
				component.Time = null
