mob/lobby
	var tmp
		Entity/player
		obj/stat_toggle
			updaters_list_stat
			physics_updaters_list_stat
			updating_components_list_stat

	proc
		Join()
			player = new /Entity/player (null, client)

			var
				Component/WeaponHandler/weapon_handler = player.GetComponent(
					/Component/WeaponHandler)
				global/vector2/start_position = new /vector2 (
					world.maxx * TILE_WIDTH / 2,
					world.maxy * TILE_HEIGHT / 2)

			player.SetCenter(start_position, 1)

			if(weapon_handler)
				var Component/Weapon/Gun/inaccurate
					rifle = new
					spread/shotgun = new

				rifle.SetBody(new /obj/gun_body/rifle)
				shotgun.SetBody(new /obj/gun_body/shotgun)

				weapon_handler.SetWeapons(list(rifle, shotgun))
				weapon_handler.EquipWeapon(rifle)

	Stat()
		statpanel("Info")
		stat("Controls", "")
		stat("Move", "WASD")
		stat("Walk", "Hold Shift")
		stat("Shoot", "Hold LMB")
		stat("Aim", "Hold RMB")
		stat("Cycle Weapons", "Mouse Scroll")
		stat("Options", "F1")
		stat("Resize", "F3")
		stat("Quit", "Escape")

		statpanel("DEBUG")

		stat("world.cpu", "[world.cpu]%")

		stat("Updating Entities",
			"[EntityUpdateLoop && length(EntityUpdateLoop.updaters)]")
		updaters_list_stat.SetText(
			jointext_short(EntityUpdateLoop.updaters, ", \n"))
		stat(updaters_list_stat)

		stat("Physics Updaters",
			"[PhysicsLoop && length(PhysicsLoop.updaters)]")
		physics_updaters_list_stat.SetText(
			jointext_short(PhysicsLoop.updaters, ", \n"))
		stat(physics_updaters_list_stat)

		var updating_components[0]
		for(var/Entity/e)
			if(e.IsUpdateEnabled() && length(e._updatable_components))
				updating_components += e._updatable_components
		stat("Updating Components", "[length(updating_components)]")
		updating_components_list_stat.SetText(
			jointext_short(updating_components, ", \n"))
		stat(updating_components_list_stat)

	Login()
		Join()
		updaters_list_stat = new
		physics_updaters_list_stat = new
		updating_components_list_stat = new

	Logout()
		key = null
		loc = null
		if(player)
			player.Destroy()

obj/gun_body
	icon_state = "rect"
	color = "black"

	rifle
		transform = matrix(3/32, 0, 0, 0, 24/32, 24)

	shotgun
		transform = matrix(5/32, 0, 0, 0, 20/32, 20)


proc
	/* Return a shortened form of a potentially long list.
	The result is a comma-separated sequence of no more than 6 entries,
	always including the first and last 3 items.
	*/
	jointext_short(List[], Separator = ", ", EndCount = 5)
		var length = length(List)
		if(length == 0)
			return null

		if(length in 1 to 2*EndCount)
			return jointext(List, Separator)

		return "[jointext(List, Separator, 1, EndCount + 1)]\
			[Separator]...([length - 2*EndCount] more)...[Separator]\
			[jointext(List, Separator, -EndCount, length)]"

obj/stat_toggle
	var tmp
		_is_showing
		_text

	proc
		IsShowing()
			return _is_showing

		SetShowing(Value)
			_is_showing = Value
			name = Value ? _text || " " : "(show)"

		GetText()
			return _text

		SetText(Value)
			_text = "[Value]"
			SetShowing(IsShowing())

	New(Text = "", IsShowing = FALSE)
		SetText(Text)
		SetShowing(IsShowing)

	MouseDown()
		SetShowing(!IsShowing())
