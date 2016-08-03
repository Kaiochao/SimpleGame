world
	name = "Shooter"

	fps = 20

	maxx = 25
	maxy = 25
	view = 12
	turf = /turf/checker

client
	fps = 60

turf/checker
	icon_state = "rect"
	color = "silver"
	New() color = (x + y) % 2 ? "#aaa" : "#bbb"

proc
	log_call(datum/Object, Message)
		world.log << "\ref[Object] \"[Object]\" [Message]"
