world
	name = "Shooter"

	fps = 20
	view = 15
	mob = /mob/lobby

	maxx = 50
	maxy = 50
	turf = /turf/random

	New()
		InitializeMap()
		..()

atom
	New()
		CheckMapInitialization()
		..()

turf
	random
		can_map_initialize = TRUE
		MapInitializing()
			if(prob(95))
				new /turf/checker (src)
			else
				new /turf/wall (src)

	wall
		icon_state = "rect"
		color = "gray"
		density = TRUE
		can_map_initialize = TRUE
		MapInitializing()
			color = (x + y) & 1 ? "#222222" : "#262626"

	checker
		icon_state = "rect"
		color = "silver"
		can_map_initialize = TRUE
		MapInitializing()
			color = (x + y) & 1 ? "#446644" : "#486a48"
