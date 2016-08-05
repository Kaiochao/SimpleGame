mob/lobby
	var
		Entity/player

	Login()
		join()

		spawn(1) while(client)
			var update_loop/Time = player.GetComponentUpdateLoop()
			winset(src, ":window", "title=\"[world.name] ([world.cpu]%, world.fps: [world.fps], dt: [Time.delta_time], updaters: [length(Time.updaters)], time: [world.time])\"")
			sleep world.tick_lag

	Logout()
		key = null
		loc = null
		if(player)
			player.Destroy()

	verb
		join()
			player = new /Entity/player (null, client)

			var
				Component
					WeaponHandler/weapon_handler = player.GetComponent(
						/Component/WeaponHandler)

					Weapon/Gun/inaccurate
						rifle
						spread/shotgun

				global/vector2/start_position = new /vector2 (
					world.maxx * TILE_WIDTH / 2,
					world.maxy * TILE_HEIGHT / 2)

			player.SetCenter(start_position, 1)

			rifle = new
			rifle.SetBody(new /obj/gun_body/rifle)

			shotgun = new
			shotgun.spread_count = 10 // 25
		//	shotgun.shot_cooldown = new /cooldown (0.5)
			shotgun.SetBody(new /obj/gun_body/shotgun)

			weapon_handler.SetWeapons(list(rifle, shotgun))
			weapon_handler.EquipWeapon(rifle)

obj/gun_body
	icon_state = "rect"
	color = "black"

	rifle
		transform = matrix(3/32, 0, 0, 0, 24/32, 24)

	shotgun
		transform = matrix(5/32, 0, 0, 0, 20/32, 20)
