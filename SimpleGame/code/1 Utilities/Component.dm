AbstractType(Component)

	var global
		update_loop/Time

	var tmp
		/* Entity that this component is attached to.
		*/
		Entity/entity

		/* Visible name of this component, including the entity's name.
		Access restricted; use [SetName(Value)] and [GetName()].
		Defaults to ["[entity.name]:[GetOwnName()]"].
		*/
		name

		/* Name of this component, excluding the attached entity's name.
		*/
		_own_name

	proc/SetName(Value)
		name = "[Value]"

	proc/GetName()
		if(isnull(name))
			SetName("[entity.name]:[GetOwnName()]")
		return name

	/* For overriding when using the default GetName() behavior.
	Defaults to the part of "[type]" after the final slash. 
	*/
	proc/GetOwnName()
		if(isnull(_own_name))
			var type_text = "[type]"
			_own_name = copytext(type_text, findlasttext(type_text, "/") + 1)
		return _own_name

	proc/GetComponent(ComponentType)
		return entity.GetComponent(ComponentType)

	/*
	Optional callbacks:
	(They're only called if they're defined)

	Start()
	Update()
	Destroy()
	*/

	Updatable
		parent_type = /Interface

		proc/Update()

	Startable
		parent_type = /Interface

		proc/Start()

	Destroyable
		parent_type = /Interface

		proc/Destroy()
