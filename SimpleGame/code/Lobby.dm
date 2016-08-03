world
	mob = /mob/lobby

client
	New()
		mob = new world.mob
		mob.name = key
		mob.gender = gender
		return ..()

mob/lobby
	Login()
		winset(src, ":map", "zoom=1")
		start()

	verb
		start()
			var Vector2/start = new (world.maxx * TILE_WIDTH / 2, world.maxy * TILE_HEIGHT / 2)
			for(var/mob/lobby/lobby)
				var mob/player/player = new
				player.SetCenter(start.x, start.y, 1)

				player.name = lobby.name
				player.gender = lobby.gender
				player.client = lobby.client

				player.SetInputHandler(player.client)
				player.SetMovementHandler(new /MovementHandler/Player)
				player.SetAimingHandler(new /AimingHandler/Player)

				var Gun
					Inaccurate/rifle = new
					Spread/shotgun = new

				rifle.SetBody(new /obj/gun)
				shotgun.SetBody(new /obj/gun/shotgun)

				player.guns = list(rifle, shotgun)
				player.EquipWeapon(player.guns[1])

obj/gun
	icon_state = "rect"
	color = "black"
	transform = matrix(3/32, 0, 0, 0, 24/32, 24)

	shotgun
		transform = matrix(5/32, 0, 0, 0, 20/32, 20)