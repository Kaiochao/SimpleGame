update_loop
	var
		callback

		updaters[]
		last_update_time[]
		delta_time

		to_update[]

	proc
		Add(Updater)
			if(!updaters)
				updaters = new
				last_update_time = new

			updaters[Updater] = TRUE
			last_update_time[Updater] = world.time - world.tick_lag

		Remove(Updater)
			if(updaters && updaters[Updater])
				updaters -= Updater

				if(!updaters.len)
					updaters = null
					last_update_time = null

				else
					last_update_time -= Updater

	New(Callback)
		if(!isnull(Callback))
			callback = Callback
			
		Start()

	proc/Start()
		set waitfor = FALSE

		for()
			if(updaters)
				while(updaters.Remove(null))
				if(!updaters.len) updaters = null

			if(updaters)
				Update()

			sleep world.tick_lag

	proc/Update()
		var global
			item
			updater
			time

		to_update = updaters.Copy()
		for(item in to_update)
			updater = item
			time = world.time
			delta_time = (1e5 * time - 1e5 * last_update_time[updater]) / 1e6
			last_update_time[updater] = time
			call(updater, callback)(src)
		to_update = null
