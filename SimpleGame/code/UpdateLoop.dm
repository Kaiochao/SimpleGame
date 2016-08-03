var UpdateLoop/update_loop = new

UpdateLoop
	var
		callback = "Update"

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

	New()
		Start()

	proc
		Start()
			set waitfor = FALSE

			for()
				if(updaters)
					while(updaters.Remove(null))
					if(!updaters.len) updaters = null

				if(updaters)
					to_update = updaters.Copy()
					Update()
					to_update = null

				sleep world.tick_lag

		Update()
			var global
				item
				updater
				time
				delta_time

			for(item in to_update)
				updater = item

				time = world.time
				delta_time = (time - last_update_time[updater]) / 10
				last_update_time[updater] = time

				call(updater, callback)(src, delta_time)
