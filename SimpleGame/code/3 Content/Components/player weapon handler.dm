Component/WeaponHandler/player
	var
		gamepad_next_weapon = GamepadButton.R1
		gamepad_previous_weapon = GamepadButton.L1
		keyboard_next_weapon = KeyButton.E
		keyboard_previous_weapon = KeyButton.Q
		gamepad_primary = GamepadButton.R2
		keyboard_primary = KeyButton.Space
		mouse_primary = MouseButton.Left

	proc
		Start()
			var InputHandler/input_handler = GetWrappedValue(/Component/Wrapper/InputHandler)
			EVENT_ADD(input_handler.MouseScrolled, src, .proc/HandleMouseScrolled)
			EVENT_ADD(input_handler.ButtonPressed, src, .proc/HandleButtonPressed)
			EVENT_ADD(input_handler.ButtonReleased, src, .proc/HandleButtonReleased)

		Destroy()
			var InputHandler/input_handler = GetWrappedValue(/Component/Wrapper/InputHandler)
			EVENT_REMOVE_OBJECT(input_handler.MouseScrolled, src)
			EVENT_REMOVE_OBJECT(input_handler.ButtonPressed, src)
			EVENT_REMOVE_OBJECT(input_handler.ButtonReleased, src)

		HandleMouseScrolled(InputHandler/InputHandler, DeltaX, DeltaY)
			if(DeltaY > 0)
				EquipNextWeapon()
			else if(DeltaY < 0)
				EquipPreviousWeapon()

		HandleButtonPressed(InputHandler/InputHandler, Button)
			if(Button == gamepad_next_weapon \
				|| Button == keyboard_next_weapon)
				EquipNextWeapon()
			else if(Button == gamepad_previous_weapon \
				|| Button == keyboard_previous_weapon)
				EquipPreviousWeapon()
			else if(Button == gamepad_primary \
				|| Button == keyboard_primary \
				|| Button == mouse_primary)
				if(Button == mouse_primary && !InputHandler.IsMouseInCamera())
					return
				SetUsing(TRUE)

		HandleButtonReleased(InputHandler/InputHandler, Button)
			if(!(InputHandler.IsButtonPressed(gamepad_primary) \
				|| InputHandler.IsButtonPressed(keyboard_primary) \
				|| InputHandler.IsButtonPressed(mouse_primary)))
				SetUsing(FALSE)
