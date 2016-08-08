client
	fps = 100

	InputHandler_Initialize()
		..()
		winset(src, "quit_macro",
			"parent=macro; name=Escape; command=\".quit\"")
		winset(src, "options_macro",
			"parent=macro; name=F1; command=\".options\"")
		winset(src, "zoom_macro", "parent=macro; name=F3; command=\
			\".winset \\\"map.zoom=2 \
				? map.zoom=1 default.size=640x480 \
				: map.zoom=2 default.size=1280x960 \\\"\"")
