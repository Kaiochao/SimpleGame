MovementHandler/Player
	var tmp
		Vector2/move_input
		InputHandler/input_handler
		Vector2/velocity

	var
		walk_speed = 80
		run_speed = 160

	proc
		Start(mob/player/Player)
			input_handler = Player.input_handler

		Destroy()
			input_handler = null

	GetVelocity()
		return velocity || ..()

	Update(mob/player/Player, DeltaTime)
		if(input_handler)

			var
				speed
				input_x
				input_y

			speed = input_handler.GetButtonState(Macro.Shift) ? run_speed : walk_speed
			if(!speed)
				velocity = null
			else
				input_x = input_handler.GetButtonState(Macro.D) - input_handler.GetButtonState(Macro.A)
				input_y = input_handler.GetButtonState(Macro.W) - input_handler.GetButtonState(Macro.S)
				if(input_x || input_y)
					if(velocity)
						velocity.x = input_x * speed
						velocity.y = input_y * speed
					else
						velocity = new (input_x * speed, input_y * speed)
				else
					velocity = null

		..()
