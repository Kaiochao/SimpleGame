client
	fps = 100

	New()
		. = ..()
		winset(src, null, {"
			info.pos=0,0;
			default.pos=672,0;
			"})

	InputHandler_Initialize()
		..()
		winset(src, "quit_macro", "parent=macro; name=Escape; command=\".quit\"")
		winset(src, "options_macro", "parent=macro; name=F1; command=\".options\"")
		winset(src, "zoom_macro", "parent=macro; name=F3; command=\
			\".winset \\\"map.zoom=1 \
				? map.zoom=0.5 default.size=480x480 \
				: map.zoom=1 default.size=960x960 \\\"\"")
