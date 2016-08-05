cooldown
	var
		clock/clock = world

		tmp
			duration
			end_time

	New(Duration)
		duration = Duration

	proc
		IsCoolingDown()
			return clock.time < end_time

		Start()
			end_time = clock.time + duration
