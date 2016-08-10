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
		vector2/_velocity
		InputHandler/_input_handler

		_move_axis_x = 0
		_move_axis_y = 0

		Directions/_move_dir = 0
		_move_button_x = 0
		_move_button_y = 0

	GetVelocity()
		return _velocity || ..()

	GetOwnName()
		return "player movement handler"

	Start()
		..()
		_input_handler = GetWrappedValue(/Component/Wrapper/InputHandler)
		if(_input_handler)
			EVENT_ADD(_input_handler.AxisChanged, src, .proc/HandleAxisChanged)
			EVENT_ADD(_input_handler.ButtonPressed, src, .proc/HandleButtonPressed)
			EVENT_ADD(_input_handler.ButtonReleased, src, .proc/HandleButtonReleased)

	Destroy()
		..()
		if(_input_handler)
			EVENT_REMOVE_OBJECT(_input_handler.AxisChanged, src)
			EVENT_REMOVE_OBJECT(_input_handler.ButtonPressed, src)
			EVENT_REMOVE_OBJECT(_input_handler.ButtonReleased, src)
			_input_handler = null

	Update()
		var
			speed
			input_x
			input_y

		speed = IsRunning() ? run_speed : walk_speed

		if(!speed)
			_velocity = null

		else
			if(_move_axis_x || _move_axis_y)
				input_x = _move_axis_x
				input_y = _move_axis_y
			else
				input_x = _move_button_x
				input_y = _move_button_y
			if(input_x || input_y)
				_velocity = new /vector2 (input_x * speed, input_y * speed)
			else
				_velocity = null

		..()

	proc
		HandleAxisChanged(InputHandler/InputHandler, Axis, X, Y)
			_move_axis_x = X
			_move_axis_y = Y

		HandleButtonPressed(InputHandler/InputHandler, Button)
			var button_dir = _ButtonToDirection(Button)
			if(button_dir)
				_SetMoveDir(_move_dir | button_dir)

		HandleButtonReleased(InputHandler/InputHandler, Button)
			var button_dir = _ButtonToDirection(Button)
			if(button_dir)
				_SetMoveDir(_move_dir & ~button_dir)

		IsRunning()
			return !(
				   _input_handler.IsButtonPressed(speed_button) \
				|| _input_handler.IsButtonPressed(gamepad_speed_button)
				)

		_ButtonToDirection(Button)
			if(Button == move_right)
				return Directions.East
			else if(Button == move_left)
				return Directions.West
			else if(Button == move_up)
				return Directions.North
			else if(Button == move_down)
				return Directions.South
			return Directions.Center

		_SetMoveDir(Value)
			if(_move_dir != Value)
				_move_dir = Value
				_move_button_x = Directions.ToOffsetX(_move_dir)
				_move_button_y = Directions.ToOffsetY(_move_dir)
