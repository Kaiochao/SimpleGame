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

	proc/StartUpdating()
		set waitfor = FALSE

		for()
			if(updaters)
				while(updaters.Remove(null))
				if(!length(updaters)) updaters = null

			if(updaters)
				UpdateUpdaters()

			sleep world.tick_lag

	proc/UpdateUpdaters()
		to_update = updaters.Copy()
		for(var/item in to_update)
			Update(item)
		to_update = null

	proc/Update(Updater)
		var time = world.time
		delta_time = (time - last_update_time[Updater]) / 10
		last_update_time[Updater] = time
		call(Updater, callback)(src)
