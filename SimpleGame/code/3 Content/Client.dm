client
	fps = 60

	New()
		var global/vignette/vignette = new (VignetteMode.ThickLight)
		vignette.Show(src)
		return ..()
