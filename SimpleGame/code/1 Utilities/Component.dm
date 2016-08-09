AbstractType(Component)
	var tmp
		/* Entity that this component is attached to.
		*/
		Entity/entity

		/* Update loop that caused this component to be updated.
		*/
		update_loop/Time

		/* Visible name of this component, including the entity's name.
		Access restricted; use [SetName(Value)] and [GetName()].
		Defaults to ["[entity.name]:[GetOwnName()]"].
		*/
		name

		/* Name of this component, excluding the attached entity's name.
		*/
		_own_name

	proc
		SetName(Value)
			name = "[Value]"

		GetName()
			if(isnull(name))
				SetName("[entity.name]:[GetOwnName()]")
			return name

		/* For overriding when using the default GetName() behavior.
		Defaults to the part of "[type]" after the final slash.
		*/
		GetOwnName()
			if(isnull(_own_name))
				var type_text = "[type]"
				_own_name = copytext(type_text, findlasttext(type_text, "/") + 1)
			return _own_name

		GetComponent(ComponentType)
			return entity.GetComponent(ComponentType)

	/* Optional callbacks, which are only called if they're defined.
	*/

	Startable
		parent_type = /Interface

		proc
			/* Called after the component is added.

			If AddComponents() is used, this not called until all of the
			components have been added.

			This may be used to get references to other components that have
			already been added.
			*/
			Start()

	Updatable
		parent_type = /Interface

		var tmp
			update_loop/Time

		proc
			/* Called every frame.
			*/
			Update()

	LateUpdatable
		parent_type = /Interface

		var tmp
			update_loop/Time

		proc
			/* Called every frame after all Update calls.
			*/
			LateUpdate()

	Destroyable
		parent_type = /Interface
		
		proc
			/* Called before the component is removed.

			If RemoveComponents() is used, this is called before any components
			have been removed.

			This should be defined to clear references to objects to allow
			garbage collection.
			*/
			Destroy()
