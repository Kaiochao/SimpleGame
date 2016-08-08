client
	fps = 100

	New()
		var global/vignette/vignette = new (VignetteMode.ThickLight)
		vignette.Show(src)
		return ..()

	InputHandler_Initialize()
		..()
		EVENT_ADD(ButtonPressed, src, .proc/HandleQuitButton)
		EVENT_ADD(ButtonPressed, src, .proc/HandleOptionsButton)

	proc
		HandleQuitButton(InputHandler/InputHandler, Button)
			if(Button == KeyButton.Escape)
				winset(src, null, "command=.quit")

		HandleOptionsButton(InputHandler/InputHandler, Button)
			if(Button == KeyButton.F1)
				winset(src, null, "command=.options")
