AimingHandler/Player
	var
		zoom_button = Macro.MouseRightButton
		aim_analog = Macro.GamepadRightAnalog

		tmp
			vector2
				_direction

			_mouse_moved = FALSE
			_has_analog_input

			_was_zooming = 0

			// The camera is offset by the vector [zoom_delta * zoom_scale] (zoom_delta in a vector2 in Update()
			_zoom_scale = 2/3

			image/_aim_line

	GetDirection()
		if(!_direction)
			_direction = new (0, 1)
		return _direction.Copy()

	proc
		Start()
			EVENT_ADD(player.input_handler.OnMouseMove, src, .proc/HandleMouseMove)

		HandleMouseMove(InputHandler/InputHandler, MoveX, MoveY)
			_mouse_moved = TRUE

		Destroy()
			EVENT_REMOVE(player.input_handler.OnMouseMove, src, .proc/HandleMouseMove)
			if(_aim_line)
				del _aim_line

		GetAimLine()
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

				_aim_line = new /image/aim_line (loc = player)

				player << _aim_line

			return _aim_line

		/*

			Check aim input from the gamepad or else from the the mouse.
			If zooming, position the camera ahead of the player by the zoom vector.

		*/
		Update()
			var
				client/client = player.client
				vector2
					aim_input = GetAnalogAimInput()
					zoom

			if(aim_input)
				_has_analog_input = TRUE

				zoom = new /vector2 (
					aim_input.GetX() * client.bound_width / 2,
					aim_input.GetY() * client.bound_height / 2)

				animate(GetAimLine(),
					alpha = aim_input.GetMagnitude() * 32,
					transform = initial(_aim_line.transform) * Math.RotationMatrix(GetDirection()),
					time = world.tick_lag)

			else
				_has_analog_input = FALSE
				aim_input = GetMouseAimInput()

				var is_zooming = player.input_handler.GetButtonState(zoom_button)
				if(is_zooming)
					zoom = aim_input.Multiply(_zoom_scale)

			if(aim_input)
				if(_has_analog_input || _mouse_moved)
					_direction = aim_input.GetNormalized()

				if(zoom)
					var
						camera_x = zoom.GetX() * _zoom_scale
						camera_y = zoom.GetY() * _zoom_scale

					if(client.pixel_x != camera_x || client.pixel_y != camera_y)
						animate(player.client,
							pixel_x = camera_x,
							pixel_y = camera_y,
							time = 1)

					_was_zooming = TRUE

				else if(_was_zooming)
					if(_aim_line)
						del _aim_line

					animate(player.client,
						pixel_x = 0,
						pixel_y = 0,
						time = 1)

					_was_zooming = FALSE

			_mouse_moved = FALSE

		GetAnalogAimInput()
			var
				analog_aim[] = player.input_handler.GetAnalog2DState(aim_analog)
				aim_x = analog_aim[1]
				aim_y = analog_aim[2]

			if(aim_x || aim_y)
				return new /vector2 (aim_x, aim_y)

		GetMouseAimInput()
			var
				mouse_position[] = player.input_handler.GetMouseMapPosition()
				player_x = player.GetCenterX()
				player_y = player.GetCenterY()
				dx = mouse_position[1] - player_x
				dy = mouse_position[2] - player_y

			if(dx || dy)
				return new /vector2 (dx, dy)
