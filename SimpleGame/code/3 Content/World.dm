world
	name = "Shooter"

	fps = 20

	maxx = 50
	maxy = 50
	view = 12
	turf = /turf/random

	mob = /mob/lobby

turf
	random
		New()
			if(prob(95))
				new /turf/checker (src)
			else
				new /turf/wall (src)

	wall
		icon_state = "rect"
		color = "gray"
		density = TRUE
		New() color = (x + y) % 2 ? "#222222" : "#262626"

	checker
		icon_state = "rect"
		color = "silver"
		New() color = (x + y) % 2 ? "#446644" : "#486a48"
