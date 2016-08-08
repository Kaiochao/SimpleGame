var Math/Math = new

Math
	var const
		E =	2.7182818284590452353602874713527
		//	2.7182817459106445f according to num2text()

	proc
		Hypot(X, Y)
			return (X || Y) ? sqrt(X * X + Y * Y) : 0

		DirectionToRotation(vector2/Vector, InitialDirection = Directions.North)
			var vector2/unit = Vector, unit_x, unit_y

			if(Vector.GetSquareMagnitude() != 1)
				unit = unit.GetNormalized()

			unit_x = unit.GetX()
			unit_y = unit.GetY()

			switch(InitialDirection)
				if(Directions.North)
					return matrix(unit_y, unit_x, 0, -unit_x, unit_y, 0)
				if(Directions.East)
					return matrix(unit_x, -unit_y, 0, unit_x, unit_y, 0)

		Interpolate(A, B, T)
			return A * (1 - T) + B * T

		Dampen(A, B, T, DeltaTime)
			if(T == 1#INF)
				return B
			return Interpolate(A, B, 1 - E ** (-T * DeltaTime))

		Ceil(N)
			return -round(-N)

		Floor(N)
			return round(N)

		Round(N, M = 1)
			return round(N, M)

		Random()
			return rand()

		RandomInteger(Lower, Upper)
			return rand(min(Lower, Upper), max(Lower, Upper))

		RandomDecimal(Lower, Upper)
			return Interpolate(min(Lower, Upper), max(Lower, Upper), Random())
