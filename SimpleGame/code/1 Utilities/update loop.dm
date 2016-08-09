update_loop
	TEMPORARY

	var
		/* Name or path of a proc defined for added updaters.
		*/
		callback

		/* Read-only: time (in seconds) since the last update.
		*/
		delta_time

		/* Set of updaters.
		*/
		updaters[]

		/* Remembers when (in terms of world.time) an updater was last updated.
		*/
		last_update_time[]

		/* Prevents multiple iteration loops in the same object.
		*/
		_is_running

	New(Callback)
		if(!isnull(Callback))
			callback = Callback

	proc
		Add(Updater)
			if(!updaters)
				updaters = new
				last_update_time = new

			if(!updaters[Updater])
				updaters[Updater] = TRUE
				last_update_time[Updater] = world.time

			if(!_is_running)
				spawn StartUpdating()

		Remove(Updater)
			if(length(updaters))
				updaters -= Updater

				if(!length(updaters))
					updaters = null
					last_update_time = null

				else
					last_update_time -= Updater

		StartUpdating()
			if(_is_running) return
			var start_time = world.time
			_is_running = start_time
			while(_is_running == start_time && length(updaters))
				while(updaters.Remove(null))
				if(!length(updaters))
					updaters = null
					break
				UpdateUpdaters()
				sleep world.tick_lag
			if(_is_running == start_time) _is_running = FALSE

		UpdateUpdaters()
			for(var/item in updaters)
				Update(item)
				sleep -1

		Update(Updater)
			var time = world.time
			delta_time = (time - last_update_time[Updater]) / 10
			last_update_time[Updater] = time
			call(Updater, callback)(src)
