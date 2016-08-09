Component/AimingHandler/player
	var
		zoom_button = MouseButton.Right
		gamepad_zoom_button = GamepadButton.L2
		aim_axis = GamepadAxis.Right

	var tmp
		_zoom_button_pressed
		_gamepad_zoom_button_pressed
		_aim_axis_x
		_aim_axis_y

		vector2
			_direction
			_aim_input
			_zoom
			_last_axis_input

		_mouse_moved = FALSE
		_has_axis_input

		_was_zooming = 0

		/* The camera is offset by the vector [zoom_delta * zoom_scale]
		[zoom_delta] is a vector2 in Update() in the direction of zoom.
		*/
		_zoom_scale = 2/3

		image/_aim_line

		client/_client
		InputHandler/_input_handler

	GetOwnName()
		return "player aiming handler"

	GetDirection()
		if(!_direction)
			_direction = new (0, 1)
		return _direction.Copy()

	proc
		Start()
			_client = GetWrappedValue(/Component/Wrapper/client)
			_input_handler = GetWrappedValue(/Component/Wrapper/InputHandler)
			EVENT_ADD(_input_handler.MouseMoved, src, .proc/HandleMouseMoved)
			EVENT_ADD(_input_handler.AxisChanged, src, .proc/HandleAxisChanged)
			EVENT_ADD(_input_handler.ButtonPressed, src, .proc/HandleButtonPressed)
			EVENT_ADD(_input_handler.ButtonReleased, src, .proc/HandleButtonReleased)

		Destroy()
			if(_aim_line)
				if(_client)
					_client.images -= _aim_line
				_aim_line = null

			if(_input_handler)
				EVENT_REMOVE_OBJECT(_input_handler.MouseMoved, src)
				EVENT_REMOVE_OBJECT(_input_handler.AxisChanged, src)
				EVENT_REMOVE_OBJECT(_input_handler.ButtonPressed, src)
				EVENT_REMOVE_OBJECT(_input_handler.ButtonReleased, src)
				_input_handler = null

			_client = null

		HandleMouseMoved(InputHandler/InputHandler, MoveX, MoveY)
			_mouse_moved = TRUE

		HandleButtonPressed(InputHandler/InputHandler, Button)
			if(Button == zoom_button)
				_zoom_button_pressed = TRUE
				StartAiming()
			else if(Button == gamepad_zoom_button)
				_gamepad_zoom_button_pressed = TRUE
				if(_zoom)
					StopAiming()
				else
					StartAiming()

		HandleButtonReleased(InputHandler/InputHandler, Button)
			if(Button == zoom_button)
				_zoom_button_pressed = FALSE
				StopAiming()

		HandleAxisChanged(InputHandler/InputHandler, Axis, X, Y)
			if(Axis == aim_axis)
				_aim_axis_x = X
				_aim_axis_y = Y

				_has_axis_input = X != 0 || Y != 0

				_UpdateAimInput()

				if(_has_axis_input)
					ShowAimLine()
				else
					HideAimLine()

		ShowAimLine()
			if(!_aim_line)
				/image/aim_line
					icon = 'shapes.dmi'
					icon_state = "rect"
					appearance_flags = RESET_COLOR | RESET_TRANSFORM
					color = "white"
					alpha = 0
					blend_mode = BLEND_ADD
					transform = matrix(3/32, 0, 0, 0, 1024/32, 1024 / 2 + 30)
					layer = OBJ_LAYER - 0.1

				_aim_line = new /image/aim_line (loc = entity)
				_client.images += _aim_line

			animate(_aim_line,
				alpha = _aim_input.GetMagnitude() * 32,
				transform = initial(_aim_line.transform) \
					* Math.DirectionToRotation(GetDirection()),
				time = world.tick_lag)

		HideAimLine()
			if(_aim_line)
				_client.images -= _aim_line
				_aim_line = null

		_UpdateAimInput()
			_aim_input = _GetAxisAimInput()
			if(_aim_input)
				_last_axis_input = _aim_input
				return

			_aim_input = _last_axis_input || _GetMouseAimInput()

		StartAiming()
			_UpdateAimInput()

			var
				scale = 1 / (2 * _aim_input.GetMagnitude())
				zoom_x = _aim_input.GetX() * _client.bound_width * scale
				zoom_y = _aim_input.GetY() * _client.bound_height * scale

			_zoom = new /vector2 (zoom_x, zoom_y)

		StopAiming()
			_zoom = null

			var Component/camera/camera = GetComponent(/Component/camera)
			if(camera)
				camera.SetAttached(TRUE)

		/* Respond to aim input from the gamepad or else from the the mouse.
		If zooming, position the camera ahead of the entity by the zoom vector.
		*/
		Update()
			_UpdateAimInput()

			if(!_aim_input)
				return

			if(_has_axis_input || _mouse_moved)
				_direction = _aim_input.GetNormalized()

			if(_mouse_moved)
				_last_axis_input = FALSE
				_mouse_moved = FALSE

			if(_zoom)
				var Component/camera/camera = GetComponent(/Component/camera)
				if(camera)
					camera.SetAttached(FALSE)
					camera.SetPosition(
						_zoom.GetX() * _zoom_scale + entity.GetCenterX(),
						_zoom.GetY() * _zoom_scale + entity.GetCenterY())

		_GetAxisAimInput()
			if(_aim_axis_x || _aim_axis_y)
				return new /vector2 (_aim_axis_x, _aim_axis_y)

		_GetMouseAimInput()
			if(!_input_handler) return

			var mouse_position[] = _input_handler.GetMouseMapPosition()
			if(!mouse_position) return

			var
				entity_x = entity.GetCenterX()
				entity_y = entity.GetCenterY()
				dx = mouse_position[1] - entity_x
				dy = mouse_position[2] - entity_y

			if(dx || dy)
				return new /vector2 (dx, dy)
