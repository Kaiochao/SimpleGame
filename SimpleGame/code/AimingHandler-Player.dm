#include "Vector2.dm"

AimingHandler/Player
	var tmp
		mob/player/player
		Vector2/direction
		degrees
		recalculate_degrees

	var
		look_ahead = FALSE

	GetDirection()
		if(!direction)
			direction = new (0, 1)
		return direction.Copy()

	proc
		Start(mob/player/Player)
			player = Player

		Destroy()
			player = null

		Update(mob/player/Player, DeltaTime)
			if(Player.input_handler)
				var Vector2
					mouse_position = Vector2.FromList(Player.input_handler.GetMouseMapPosition())
					player_position = player.GetCenterPosition()
					player_to_mouse = mouse_position.Subtract(player_position)

				if(!player_to_mouse.IsZero())
					direction = player_to_mouse.GetNormalized()

				if(look_ahead)
					var Vector2
						mouse_screen_position = Vector2.FromList(Player.input_handler.GetMouseScreenPosition())
						center_position = new (player.client.bound_width / 2, player.client.bound_height / 2)
						center_to_mouse = mouse_screen_position.Subtract(center_position)

					animate(Player.client,
						pixel_x = center_to_mouse.x / 2,
						pixel_y = center_to_mouse.y / 2,
						easing = SINE_EASING | EASE_OUT,
						time = world.tick_lag)
