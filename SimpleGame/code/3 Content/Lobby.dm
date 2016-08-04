mob/lobby
	Login()
		name = client.key
		gender = client.gender
		start()

	verb
		start()
			var
				vector2/start = new (world.maxx * TILE_WIDTH / 2, world.maxy * TILE_HEIGHT / 2)
				mob/player/player
				WeaponHandler/weapon_handler
				Gun
					inaccurate/rifle
					spread/shotgun

			for(var/mob/lobby/lobby)
				player = new
				player.SetCenter(start, 1)

				player.name = lobby.name
				player.gender = lobby.gender
				player.client = lobby.client

				EVENT_ADD(player.OnUpdate, player, /mob/player/proc/ShowCpuUsage)

				player.input_handler = player.client
				weapon_handler = new /WeaponHandler/Player

				player.AddComponents(list(
					new /MovementHandler/Player,
					new /AimingHandler/Player,
					weapon_handler))

				rifle = new
				shotgun = new
				rifle.SetBody(new /obj/gun)
				shotgun.SetBody(new /obj/gun/shotgun)

				weapon_handler.SetWeapons(list(rifle, shotgun))
				weapon_handler.EquipWeapon(rifle)

mob/player
	proc
		ShowCpuUsage()
			if(client)
				var UpdateLoop/Time = GetComponentUpdateLoop()
				winset(src, ":window", "title=\"[world.name] ([world.cpu]%, world.fps: [world.fps], dt: [Time.delta_time], time: [world.time])\"")

obj/gun
	icon_state = "rect"
	color = "black"
	transform = matrix(3/32, 0, 0, 0, 24/32, 24)

	shotgun
		transform = matrix(5/32, 0, 0, 0, 20/32, 20)