Component/WeaponHandler/player
	var
		gamepad_next_weapon = GamepadButton.R1
		gamepad_previous_weapon = GamepadButton.L1

	proc/Start()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		EVENT_ADD(input_handler.MouseScrolled, src,
			.proc/HandleMouseScrolled)
		EVENT_ADD(input_handler.ButtonPressed, src,
			.proc/HandleButtonPressed)

	proc/Destroy()
		var InputHandler/input_handler = GetWrappedValue(
			/Component/Wrapper/InputHandler)
		EVENT_REMOVE_OBJECT(input_handler.MouseScrolled, src)
		EVENT_REMOVE_OBJECT(input_handler.ButtonPressed, src)

	proc/HandleMouseScrolled(InputHandler/InputHandler, DeltaX, DeltaY)
		if(DeltaY > 0)
			EquipNextWeapon()
		else if(DeltaY < 0)
			EquipPreviousWeapon()

	proc/HandleButtonPressed(InputHandler/InputHandler, Button)
		if(Button == gamepad_next_weapon)
			EquipNextWeapon()
		else if(Button == gamepad_previous_weapon)
			EquipPreviousWeapon()

	proc/EquipNextWeapon()
		var Component/Weapon/weapons[] = GetWeapons()

		if(!length(weapons))
			return

		var index = weapons.Find(_weapon) + 1

		if(index < 1)
			index = length(weapons)
		else if(index > length(weapons))
			index = 1

		EquipWeapon(weapons[index])

	proc/EquipPreviousWeapon()
		var Component/Weapon/weapons[] = GetWeapons()

		if(!length(weapons))
			return

		var index = weapons.Find(_weapon) - 1

		if(index < 1)
			index = length(weapons)
		else if(index > length(weapons))
			index = 1

		EquipWeapon(weapons[index])
