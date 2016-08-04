AimingHandler/Player
	var
		zoom_button = Macro.MouseRightButton
		aim_analog = Macro.GamepadRightAnalog

		tmp
			vector2
				_direction
				_last_mouse_screen_position

			_degrees
			_recalculate_degrees

			_is_zooming = 0

			// The camera is offset by the vector [zoom_delta * zoom_scale] (zoom_delta in a vector2 in Update()
			_zoom_scale = 2/3

			image/_aim_line

	GetDirection()
		if(!_direction)
			_direction = new (0, 1)
		return _direction.Copy()

	proc
		Destroy()
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

		Update()
			var vector2
				aim_analog_input = vector2.FromList(player.input_handler.GetAnalog2DState(aim_analog))
				has_analog_input = !aim_analog_input.IsZero()

			if(has_analog_input)
				_direction = aim_analog_input.GetNormalized()

			else
				var vector2
					mouse_position = vector2.FromList(player.input_handler.GetMouseMapPosition())
					mouse_screen_position = vector2.FromList(player.input_handler.GetMouseScreenPosition())
					player_position = player.GetCenterPosition()
					player_to_mouse = mouse_position.Subtract(player_position)

				if(!player_to_mouse.IsZero() && !mouse_screen_position.Equals(_last_mouse_screen_position))
					_last_mouse_screen_position = mouse_screen_position
					_direction = player_to_mouse.GetNormalized()

			var previous_is_zooming = _is_zooming
			_is_zooming = has_analog_input || player.input_handler.GetButtonState(zoom_button)

			if(_is_zooming)
				var vector2
					mouse_screen_position = vector2.FromList(player.input_handler.GetMouseScreenPosition())
					center_position = new (player.client.bound_width / 2, player.client.bound_height / 2)
					zoom_delta

				if(has_analog_input)
					zoom_delta = new /vector2 (
						aim_analog_input.GetX() * player.client.bound_width / 2,
						aim_analog_input.GetY() * player.client.bound_height / 2)

					animate(GetAimLine(),
						alpha = aim_analog_input.GetMagnitude() * 32,
						transform = initial(_aim_line.transform) * Math.RotationMatrix(GetDirection()),
						time = world.tick_lag)
				else
					zoom_delta = mouse_screen_position.Subtract(center_position)

				animate(player.client,
					pixel_x = zoom_delta.GetX() * (2/3),
					pixel_y = zoom_delta.GetY() * (2/3),
					time = 1)

			else if(previous_is_zooming)
				if(_aim_line)
					del _aim_line

				animate(player.client,
					pixel_x = 0,
					pixel_y = 0,
					time = 1)
