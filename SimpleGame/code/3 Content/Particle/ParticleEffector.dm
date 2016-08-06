AbstractType(Component/ParticleEffector)
	proc
		Pool()
			var Entity/particle/particle = entity
			particle.Pool()

	smoke
		proc/Start()
			var time = Math.RandomDecimal(1, 2)
			spawn(time) Pool()

			var mutable_appearance/mup = new (entity)
			mup.icon_state = "oval"
			mup.transform = matrix(4/32, 0, 0, 0, 4/32, 0)
			mup.color = "silver"
			entity.appearance = mup
			animate(entity,
				transform = matrix(
					1, 0, Math.RandomDecimal(-4, 4),
					0, 1, Math.RandomDecimal(-4, 4)),
				alpha = 0,
				time = time)
