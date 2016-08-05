AbstractType(Component)

	var global/update_loop/Time

	var tmp/Entity/entity

	proc/GetComponent(ComponentType)
		return entity.GetComponent(ComponentType)

	/*
		Optional callbacks:
		(They're only called if they're defined)

		Start()
		Update()
		Destroy()
	*/

	Updater
		parent_type = /Interface

		proc/Update()

	Starter
		parent_type = /Interface

		proc/Start()

	Destroyer
		parent_type = /Interface

		proc/Destroy()
