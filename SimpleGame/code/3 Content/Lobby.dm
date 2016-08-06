/*
	Return a shortened form of a potentially long list.
	The result is a comma-separated sequence of no more than 6 entries,
	always including the first and last 3 items.
*/
proc/jointext_short(List[], Separator = ", ", EndCount = 3)
	var length = length(List)
	switch(length)
		if(0)
			return null

		if(1 to 6)
			return jointext(List, Separator)

		else
			return "[jointext(List, Separator, 1, EndCount + 1)]\
				[Separator]...[Separator]\
				[jointext(List, Separator, -EndCount, length)]"

obj/stat_toggle
	var _is_showing = FALSE

	proc/IsShowing() return _is_showing
	proc/SetShowing(Value)
		_is_showing = Value
		name = Value ? _text || " " : "(show)"

	var _text = ""
	proc/GetText() return _text
	proc/SetText(Value)
		_text = "[Value]"
		SetShowing(IsShowing())

	New() SetShowing(IsShowing())

	MouseDown() SetShowing(!IsShowing())

mob/lobby
	var tmp
		Entity/player
		obj/stat_toggle
			updaters_list_stat
			physics_updaters_list_stat

	Login()
		Join()
		updaters_list_stat = new
		physics_updaters_list_stat = new

	Stat()
		var
			update_loop/Time = component_loop
			update_loop/Physics = physics_loop

		statpanel("DEBUG")

		stat("world.cpu", "[world.cpu]%")

		stat("Updating Entities", "[Time && length(Time.updaters)]")
		updaters_list_stat.SetText(
			jointext_short(Time.updaters, ", \n"))
		stat(updaters_list_stat)

		stat("Physics Updaters", "[Physics && length(Physics.updaters)]")
		physics_updaters_list_stat.SetText(
			jointext_short(Physics.updaters, ", \n"))
		stat(physics_updaters_list_stat)

	Logout()
		key = null
		loc = null
		if(player)
			player.Destroy()

	proc/Join()
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

		if(weapon_handler)
			rifle = new
			rifle.SetBody(new /obj/gun_body/rifle)

			shotgun = new
		//	shotgun.spread_count = 25
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
