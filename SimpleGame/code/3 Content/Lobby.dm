mob/lobby
	var tmp
		Entity/player

		// Debug information
		stat_toggle
			stat_toggle_updaters
			stat_toggle_physics_updaters
			stat_toggle_updating_components

	Stat()
		Stat_DisplayControlsPanel()
		Stat_DisplayDebugPanel()

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

		Stat_DisplayControlsPanel()
			statpanel("Controls")
			stat("Move", "WASD")
			stat("Walk", "Hold Shift")
			stat("Shoot", "Hold LMB")
			stat("Aim", "Hold RMB")
			stat("Cycle Weapons", "Mouse Scroll")
			stat("Options", "F1")
			stat("Resize", "F3")
			stat("Quit", "Escape")

		Stat_DisplayDebugPanel()
			statpanel("DEBUG")
			stat("world.cpu", "[world.cpu]%")
			Stat_DisplayUpdatingEntities()
			Stat_DisplayUpdatingComponents()
			Stat_DisplayPhysicsUpdaters()

		Stat_DisplayToggleList(list/List, stat_toggle/StatToggle, Title)
			var stat_text
			if(List)
				stat_text = "[length(List)]"
				StatToggle.SetText(jointext_short(List, ", \n"))
			else
				stat_text = "None"
				StatToggle.SetText()
			stat(Title, stat_text)
			stat(StatToggle)

		Stat_DisplayUpdatingEntities()
			if(player && player.update_loop)
				Stat_DisplayToggleList(player.update_loop.updaters, stat_toggle_updaters, "Updating Entities")

		Stat_DisplayPhysicsUpdaters()
			var Component/physics/physics = player.GetComponent(/Component/physics)
			if(physics && physics.update_loop)
				Stat_DisplayToggleList(physics.update_loop.updaters, stat_toggle_physics_updaters, "Physics Updaters")

		// Display components that are updating and late-updating
		Stat_DisplayUpdatingComponents()
			var updating_components[0]

			// Find all updating components of enabled entities
			for(var/Entity/e)
				if(e.IsUpdateEnabled() && length(e._updatable_components))
					updating_components += e._updatable_components

			// Find all late-updating components of enabled entities
			for(var/Entity/e)
				if(e.IsUpdateEnabled() && length(e._late_updatable_components))
					updating_components += e._late_updatable_components

			Stat_DisplayToggleList(updating_components, stat_toggle_updating_components, "Updating Components")

	Login()
		Join()
		stat_toggle_updaters = new
		stat_toggle_physics_updaters = new
		stat_toggle_updating_components = new

	Logout()
		..()
		key = null
		loc = null
		if(player)
			player.Destroy()

obj/gun_body
	icon_state = "rect"
	color = rgb(0, 0, 0)

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

stat_toggle
	parent_type = /obj
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
