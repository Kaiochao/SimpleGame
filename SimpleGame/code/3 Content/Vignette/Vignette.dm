ENUM(VignetteMode)
	None = ""
	ThinLight = "thin light"
	ThinDark = "thin dark"
	ThickLight = "thick light"
	ThickDark = "thick dark"

vignette
	var
		icon = 'vignette.dmi'
		mode

		screen[]

	New(Mode) SetMode(Mode)

	proc
		Show(client/Client)
			if(!screen) MakeScreenObjects()
			Client.screen += screen

		Hide(client/Client)
			Client.screen -= screen

		SetMode(Mode)
			mode = Mode
			if(screen)
				for(var/obj/o in screen)
					o.icon_state = mode

		MakeScreenObjects()
			if(!screen)
				screen = new (4)

				var obj/o

				var appearance

				// north edge
				o = new

				// one-time appearance setup
				o.icon = icon
				o.icon_state = mode
				o.mouse_opacity = FALSE
				o.layer = 100
				appearance = o.appearance

				o.screen_loc = "NORTHWEST to NORTHEAST"
				screen[1] = o

				// south
				o = new
				o.appearance = appearance
				o.screen_loc = "SOUTHWEST to SOUTHEAST"
				o.transform = matrix(1, -1, MATRIX_SCALE)
				screen[2] = o

				// east
				o = new
				o.appearance = appearance
				o.screen_loc = "SOUTHEAST to NORTHEAST"
				o.transform = turn(o.transform, 90)
				screen[3] = o

				// west
				o = new
				o.appearance = appearance
				o.screen_loc = "SOUTHWEST to NORTHWEST"
				o.transform = turn(o.transform, -90)
				screen[4] = o

			return screen

#if 0
var vignette_generator/vignette_generator = new

vignette_generator
	New() Generate(32, 32)

	proc
		Generate(Width, Height)
			var
				icon/i = icon('icons/blank.dmi')

			i.Crop(1, 1, Width, Height)

			for(var/x in 1 to Height)
				var alpha = max(0, 3 * floor(256 / 2 ** (x * 0.4))) // <-- math goes here

				if(alpha > 0)
					i.DrawBox(rgb(0, 0, 0, alpha), 1, 1 + Height - x, Width, 1 + Height - x)

			fcopy(i, "generated vignette.dmi")

			world.log << "generated vignette"
#endif