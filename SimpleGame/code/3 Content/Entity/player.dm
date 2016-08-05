/*

	I'm using an overlay for the player's body so that weapons
	(whose bodies are added to the entity's underlays)
	can be transformed by the player, while being unaffected
	by the player's default appearance.

*/

Entity/player
	icon = null

	bounds = "24,24"
	pixel_x = (24 - 32) / 2
	pixel_y = (24 - 32) / 2

	overlays = list(/obj/player_body)

	var client/client

	New(atom/Loc, client/Client)
		client = Client
		name = Client.key
		gender = Client.gender
		..()

	AddDefaultComponents()
		var Component
			Wrapper
				Client/client_wrapper = new
				InputHandler/input_handler_wrapper = new
			WeaponHandler/weapon_handler = new /Component/WeaponHandler/player
			physics/physics = new

		client_wrapper.Set(client)
		input_handler_wrapper.Set(client)

		AddComponents(
			list(
				client_wrapper,
				input_handler_wrapper,
				physics,
				weapon_handler
			) + newlist(
				/Component/Camera,
				/Component/MovementHandler/player,
				/Component/AimingHandler/player
			)
		)

		physics.translate_flags = TranslateFlags.EnableSliding

obj/player_body
	icon_state = "oval"
	color = "blue"
	transform = matrix(24/32, 0, 0, 0, 24/32, 0)
