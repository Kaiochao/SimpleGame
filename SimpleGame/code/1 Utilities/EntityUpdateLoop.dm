/* Modified update loop that adds a "late update" stage, after the normal update.
*/
update_loop/Entity
	var
		last_late_update_time[]

	Add(Updater)
		..()
		if(!last_late_update_time)
			last_late_update_time = new
		last_late_update_time[Updater] = world.time

	Remove(Updater)
		..()
		if(updaters)
			last_late_update_time -= Updater
		else
			last_late_update_time = null

	UpdateUpdaters()
		var item, time, Entity/entity, const/units = 0.1

		for(item in updaters)
			entity = item
			time = world.time
			delta_time = (time - last_update_time[item]) * units
			last_update_time[item] = time
			entity.UpdateComponents(src)
			sleep -1

		for(item in updaters)
			entity = item
			time = world.time
			delta_time = (time - last_late_update_time[item]) * units
			last_late_update_time[item] = time
			entity.LateUpdateComponents(src)
			sleep -1
