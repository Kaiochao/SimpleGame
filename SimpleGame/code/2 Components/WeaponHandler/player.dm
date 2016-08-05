Component/WeaponHandler/player
	var
		gamepad_next_weapon = Macro.GamepadR1
		gamepad_previous_weapon = Macro.GamepadL1

	proc/Start()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		EVENT_ADD(input_handler.OnMouseWheel, src, .proc/HandleMouseWheel)
		EVENT_ADD(input_handler.OnButton, src, .proc/HandleButton)

	proc/Destroy()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		EVENT_REMOVE_OBJECT(input_handler.OnMouseWheel, src)
		EVENT_REMOVE_OBJECT(input_handler.OnButton, src)

	proc/HandleMouseWheel(InputHandler/InputHandler, DeltaX, DeltaY)
		if(DeltaY > 0)
			EquipNextWeapon()
		else
			EquipPreviousWeapon()

	proc/HandleButton(
		InputHandler/InputHandler,
		Macro/Macro,
		ButtonState/ButtonState)
		if(ButtonState)
			if(Macro == gamepad_next_weapon)
				EquipNextWeapon()
			else if(Macro == gamepad_previous_weapon)
				EquipPreviousWeapon()

	proc/EquipNextWeapon()
		var Component/Weapon/weapons[] = GetWeapons()

		if(!(weapons && weapons.len))
			return

		var index = weapons.Find(_weapon) + 1

		if(index < 1)
			index = weapons.len
		else if(index > weapons.len)
			index = 1

		EquipWeapon(weapons[index])

	proc/EquipPreviousWeapon()
		var Component/Weapon/weapons[] = GetWeapons()

		if(!(weapons && weapons.len))
			return

		var index = weapons.Find(_weapon) - 1

		if(index < 1)
			index = weapons.len
		else if(index > weapons.len)
			index = 1

		EquipWeapon(weapons[index])
