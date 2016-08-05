mob/lobby
	Login()
		name = client.key
		gender = client.gender
		join()

	Logout()
		key = null
		loc = null

	verb
		join()
			var
				vector2/start = new (world.maxx * TILE_WIDTH / 2, world.maxy * TILE_HEIGHT / 2)
				mob/player/player
				WeaponHandler/weapon_handler
				Gun
					inaccurate/rifle
					spread/shotgun

			player = new
			player.name = name
			player.gender = gender
			player.client = client
			player.input_handler = player.client

			EVENT_ADD(player.OnUpdate, player, /mob/player/proc/ShowCpuUsage)

			player.AddComponents(newlist(
				/MovementHandler/Player,
				/AimingHandler/Player,
				/WeaponHandler/Player))

			weapon_handler = player.GetComponent(/WeaponHandler)
			if(weapon_handler)
				rifle = new
				rifle.SetBody(new /obj/gun)

				shotgun = new
				shotgun.spread_count = 25
				shotgun.shot_cooldown = new /cooldown (0.5)
				shotgun.SetBody(new /obj/gun/shotgun)

				weapon_handler.SetWeapons(list(rifle, shotgun))
				weapon_handler.EquipWeapon(rifle)

			player.SetCenter(start, 1)

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