AbstractType(Component)

	var
		global
			UpdateLoop/Time

		tmp
			mob/player/player

	/*
		Optional callbacks:
		(They're only called if they're defined)

		Start()
		Update()
		Destroy()
	*/

	Updater
		parent_type = /Interface

		proc
			Update()

	Starter
		parent_type = /Interface

		proc
			Start()

	Destroyer
		parent_type = /Interface

		proc
			Destroy()