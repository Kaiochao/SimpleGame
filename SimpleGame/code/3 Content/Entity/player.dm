Entity/player
	icon = null

	density = TRUE
	bounds = "24,24"
	pixel_x = (24 - 32) / 2
	pixel_y = (24 - 32) / 2

	/*
	I'm using an overlay for the player's body so that weapons
	(whose bodies are added to the entity's underlays)
	can be transformed (rotated) with the player, while being unaffected
	by the player's default appearance.
	*/
	overlays = list(/obj/player_body)

	/obj/player_body
		icon_state = "oval"
		color = "blue"
		transform = matrix(24/32, 0, 0, 0, 24/32, 0)

	var tmp
		client/_client

	New(atom/Loc, client/Client)
		_client = Client
		name = Client.key
		gender = Client.gender
		..()

	AddDefaultComponents()
		var Component
			Wrapper
				client/client_wrapper = new
				InputHandler/input_handler_wrapper = new
			WeaponHandler/weapon_handler = new /Component/WeaponHandler/player
			physics/physics = new
			camera/camera = new

		client_wrapper.Set(_client)
		input_handler_wrapper.Set(_client)

		AddComponents(
			list(
				client_wrapper,
				input_handler_wrapper,
				physics,
				weapon_handler,
				camera,
			) + newlist(
				/Component/MovementHandler/player,
				/Component/AimingHandler/player,
			)
		)

		physics.translate_flags = TranslateFlags.EnableSliding
		camera.speed = 5
