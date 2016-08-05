world
	name = "Shooter"

	fps = 20

	maxx = 50
	maxy = 50
	view = 12
	turf = /turf/checker

turf/checker
	icon_state = "rect"
	color = "silver"
	New() color = (x + y) % 2 ? "#446644" : "#486a48"
