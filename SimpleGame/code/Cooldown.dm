#include <Kaiochao\Clock\Clock.dme>

var clock/cooldown_clock = world

Cooldown
	var tmp
		duration
		end_time

	New(Duration)
		duration = Duration

	proc
		IsCoolingDown()
			return cooldown_clock.time < end_time

		Start()
			end_time = cooldown_clock.time + duration
