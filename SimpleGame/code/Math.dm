var Math/Math = new

Math
	var const
		E =	2.7182818284590452353602874713527
		//	2.7182817459106445f according to num2text()

	proc
		Hypotenuse(X, Y)
			return (X || Y) ? sqrt(X * X + Y * Y) : 0

		RotationMatrix(Vector2/Vector, InitialDirection = Directions.North)
			var Vector2/unit = Vector

			if(Vector.GetSquareMagnitude() != 1)
				unit = unit.GetNormalized()

			switch(InitialDirection)
				if(Directions.North)
					return matrix(unit.y, unit.x, 0, -unit.x, unit.y, 0)
				if(Directions.East)
					return matrix(unit.x, -unit.y, 0, unit.x, unit.y, 0)

		Interpolate(A, B, T)
			return A * (1 - T) + B * T

		Dampen(A, B, T, DeltaTime)
			return Interpolate(A, B, 1 - E ** (-T * DeltaTime))

		Ceil(N)
			return -round(-N)

		Floor(N)
			return round(N)

		Round(N, M = 1)
			return round(N, M)
