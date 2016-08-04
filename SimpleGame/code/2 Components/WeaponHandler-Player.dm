WeaponHandler/Player
	var
		gamepad_next_weapon = Macro.GamepadR1
		gamepad_previous_weapon = Macro.GamepadL1

	proc
		Start()
			EVENT_ADD(player.input_handler.OnMouseWheel, src, .proc/HandleMouseWheel)
			EVENT_ADD(player.input_handler.OnButton, src, .proc/HandleButton)

		Destroy()
			EVENT_REMOVE_OBJECT(player.input_handler.OnMouseWheel, src)

		HandleMouseWheel(InputHandler/InputHandler, DeltaX, DeltaY)
			if(DeltaY > 0)
				EquipNextWeapon()
			else
				EquipPreviousWeapon()

		HandleButton(InputHandler/InputHandler, Macro/Macro, ButtonState/ButtonState)
			if(ButtonState)
				if(Macro == gamepad_next_weapon)
					EquipNextWeapon()
				else if(Macro == gamepad_previous_weapon)
					EquipPreviousWeapon()

		EquipNextWeapon()
			var weapons[] = GetWeapons()
			var index = weapons.Find(_weapon) + 1
			if(index < 1) index = weapons.len
			else if(index > weapons.len) index = 1
			EquipWeapon(weapons[index])

		EquipPreviousWeapon()
			var weapons[] = GetWeapons()
			var index = weapons.Find(_weapon) - 1
			if(index < 1) index = weapons.len
			else if(index > weapons.len) index = 1
			EquipWeapon(weapons[index])
