Component/MovementHandler/player
	var
		walk_speed = 80
		run_speed = 160

		move_axis = GamepadAxis.Left
		move_right = KeyButton.D
		move_left = KeyButton.A
		move_up = KeyButton.W
		move_down = KeyButton.S

		speed_button = KeyButton.Shift
		gamepad_speed_button = GamepadButton.L3

	var tmp
		vector2/velocity
		InputHandler/_input_handler

	GetVelocity()
		return velocity || ..()

	GetOwnName()
		return "player movement handler"

	Start()
		..()
		_input_handler = GetWrappedValue(/Component/Wrapper/InputHandler)

	Destroy()
		..()
		_input_handler = null

	Update()
		var
			speed
			input_x
			input_y

		speed = IsRunning() ? run_speed : walk_speed

		if(!speed)
			velocity = null

		else
			var vector2/move_axis_input = vector2.FromList(
				_input_handler.GetAxisValues(move_axis))

			if(move_axis_input.IsZero())
				input_x = _input_handler.IsButtonPressed(move_right) \
						- _input_handler.IsButtonPressed(move_left)
				input_y = _input_handler.IsButtonPressed(move_up) \
						- _input_handler.IsButtonPressed(move_down)
				if(input_x && input_y)
					var magnitude = Math.Hypot(input_x, input_y)
					input_x /= magnitude
					input_y /= magnitude
			else
				input_x = move_axis_input.GetX()
				input_y = move_axis_input.GetY()

			if(input_x || input_y)
				velocity = new (input_x * speed, input_y * speed)
			else
				velocity = null

		..()

	proc
		IsRunning()
			return !(
				   _input_handler.IsButtonPressed(speed_button) \
				|| _input_handler.IsButtonPressed(gamepad_speed_button)
				)
