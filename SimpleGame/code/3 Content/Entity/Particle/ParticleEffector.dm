AbstractType(Component/ParticleEffector)
	proc
		Pool()
			var Entity/particle/particle = entity
			particle.Pool()

	smoke
		proc
			Start()
				var time = Math.RandomDecimal(1, 2)
				spawn(time) Pool()

				var global
					mutable_appearance
						m1
						m2

				if(!m1)
					m1 = new (entity)
					m1.icon_state = "oval"
					m1.transform = matrix(4/32, 0, 0, 0, 4/32, 0)
					m1.color = "silver"

					m2 = new (m1)
					m2.transform = matrix()
					m2.alpha = 0

				entity.appearance = m1
				animate(entity, appearance = m2, time = time)
