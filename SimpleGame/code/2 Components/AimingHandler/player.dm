Component/AimingHandler/player
	var
		zoom_button = MouseButton.Right
		aim_axis = GamepadAxis.Right

	var tmp
		vector2
			_direction
			_aim_input

		_mouse_moved = FALSE
		_has_axis_input

		_was_zooming = 0

		/* The camera is offset by the vector [zoom_delta * zoom_scale]
		[zoom_delta] is a vector2 in Update() in the direction of zoom.
		*/
		_zoom_scale = 1/2

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
			_client = GetWrappedValue(/Component/Wrapper/Client)
			_input_handler = GetWrappedValue(/Component/Wrapper/InputHandler)
			EVENT_ADD(_input_handler.MouseMoved, src, .proc/HandleMouseMoved)

		HandleMouseMoved(InputHandler/InputHandler, MoveX, MoveY)
			_mouse_moved = TRUE

		Destroy()
			if(_aim_line)
				if(_client)
					_client.images -= _aim_line
				_aim_line = null

			if(_input_handler)
				EVENT_REMOVE_OBJECT(_input_handler.MouseMoved, src)
				_input_handler = null

			_client = null

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
				_has_axis_input = TRUE
			else
				_has_axis_input = FALSE
				_aim_input = _GetMouseAimInput()

		/* Respond to aim input from the gamepad or else from the the mouse.
		If zooming, position the camera ahead of the entity by the zoom vector.
		*/
		Update()
			var
				client/client = _client
				InputHandler/input_handler = _input_handler
				vector2/zoom

			_UpdateAimInput()

			if(!_aim_input)
				HideAimLine()
				return

			if(_has_axis_input)
				zoom = new /vector2 (
					_aim_input.GetX() * client.bound_width / 2,
					_aim_input.GetY() * client.bound_height / 2)
				ShowAimLine()

			else
				var is_zooming = input_handler.IsButtonPressed(zoom_button)
				if(is_zooming)
					zoom = _aim_input.Multiply(_zoom_scale)

			if(_has_axis_input || _mouse_moved)
				_direction = _aim_input.GetNormalized()

			var Component/Camera/camera = GetComponent(/Component/Camera)
			if(camera)
				var
					camera_x = 0
					camera_y = 0

				if(zoom)
					camera_x = zoom.GetX() * _zoom_scale
					camera_y = zoom.GetY() * _zoom_scale
					_was_zooming = TRUE

				else if(_was_zooming)
					HideAimLine()
					_was_zooming = FALSE

				camera.SetPosition(
					camera_x + entity.GetCenterX(),
					camera_y + entity.GetCenterY())

			_mouse_moved = FALSE

		_GetAxisAimInput()
			var InputHandler/input_handler = _input_handler
			if(!input_handler) return

			var
				axis_aim[] = input_handler.GetAxisValues(aim_axis)
				aim_x = axis_aim[1]
				aim_y = axis_aim[2]

			if(aim_x || aim_y)
				return new /vector2 (aim_x, aim_y)

		_GetMouseAimInput()
			var InputHandler/input_handler = _input_handler
			if(!input_handler) return

			var mouse_position[] = input_handler.GetMouseMapPosition()
			if(!mouse_position) return

			var
				entity_x = entity.GetCenterX()
				entity_y = entity.GetCenterY()
				dx = mouse_position[1] - entity_x
				dy = mouse_position[2] - entity_y

			if(dx || dy)
				return new /vector2 (dx, dy)
