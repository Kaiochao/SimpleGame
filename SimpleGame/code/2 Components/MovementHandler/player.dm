Component/MovementHandler/player
	var
		walk_speed = 80
		run_speed = 160

		move_analog = GamepadAxis.Left
		move_right = KeyButton.D
		move_left = KeyButton.A
		move_up = KeyButton.W
		move_down = KeyButton.S

		speed_button = KeyButton.Shift
		gamepad_speed_button = GamepadButton.L3

		tmp
			vector2
				velocity

	GetVelocity()
		return velocity || ..()

	GetOwnName()
		return "player movement handler"

	Update()
		var
			speed
			input_x
			input_y
			InputHandler/input_handler = entity.GetWrappedValue(
				/Component/Wrapper/InputHandler)

		speed = IsRunning() ? run_speed : walk_speed

		if(!speed)
			velocity = null

		else
			var vector2/move_analog_input = vector2.FromList(
				input_handler.GetAxisValues(move_analog))
			if(move_analog_input.IsZero())
				input_x = input_handler.IsButtonPressed(move_right) \
						- input_handler.IsButtonPressed(move_left)
				input_y = input_handler.IsButtonPressed(move_up) \
						- input_handler.IsButtonPressed(move_down)
				if(input_x && input_y)
					var magnitude = Math.Hypot(input_x, input_y)
					input_x /= magnitude
					input_y /= magnitude
			else
				input_x = move_analog_input.GetX()
				input_y = move_analog_input.GetY()

			if(input_x || input_y)
				velocity = new (input_x * speed, input_y * speed)
			else
				velocity = null

		..()

	proc
		IsRunning()
			var InputHandler/input_handler = entity.GetWrappedValue(
				/Component/Wrapper/InputHandler)
			return !(input_handler.IsButtonPressed(speed_button) \
				|| input_handler.IsButtonPressed(gamepad_speed_button))
