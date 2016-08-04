client
	fps = 60

	New()
		var global/vignette/vignette = new (VignetteMode.ThickLight)
		vignette.Show(src)

		mob = new /mob/lobby
		mob.name = key
		mob.gender = gender

		return ..()
