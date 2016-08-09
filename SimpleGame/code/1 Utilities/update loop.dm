update_loop
	var
		callback

		updaters[]
		last_update_time[]
		delta_time

	proc
		Add(Updater)
			if(!updaters)
				updaters = new
				last_update_time = new

			updaters[Updater] = TRUE
			last_update_time[Updater] = world.time

		Remove(Updater)
			if(length(updaters))
				updaters -= Updater

				if(!length(updaters))
					updaters = null
					last_update_time = null

				else
					last_update_time -= Updater

	New(Callback)
		if(!isnull(Callback))
			callback = Callback

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
