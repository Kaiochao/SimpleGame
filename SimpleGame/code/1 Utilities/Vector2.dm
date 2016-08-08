#include <Kaiochao\Enum\Enum.dme>

#define VECTOR2_ZERO (new /vector2 (0, 0))

ENUM(Vector2Flags)
	Modify = 1

var Vector2Static/vector2 = new

Vector2Static
	proc
		FromList(List[])
			return new /vector2 (List[1], List[2])

		// Tip: If you're using [atan2(X, Y)] to provide the angle here,
		// you should instad use [vector2.ScaleToMagnitude(new /vector2 (X, Y), Magnitude)].
		// or [normalized.Multiply(Magnitude)] if you have a normalized vector (X, Y).
		FromPolar(Magnitude, DegreesClockwiseFromNorth)
			return new /vector2 (
				Magnitude * sin(DegreesClockwiseFromNorth),
				Magnitude * cos(DegreesClockwiseFromNorth))

		ScaleToMagnitude(vector2/Direction, Magnitude)
			var
				x = Direction.GetX()
				y = Direction.GetY()
			if(x || y)
				var s = Magnitude / Math.Hypot(x, y)
				return new /vector2 (x * s, y * s)
			else
				return VECTOR2_ZERO

// Immutable
vector2
	var
		_x
		_y

	New(X = 0, Y = X)
		if(isnum(X) && isnum(Y))
			goto BODY

		if(istype(X, /vector2))
			var vector2/v = X
			X = v._x
			Y = v._y
			goto BODY

		CRASH("Unexpected argument form.")

		BODY

		_x = X
		_y = Y

	proc
		GetX()
			return _x

		GetY()
			return _y

		Copy()
			return new /vector2 (_x, _y)

		Equals(vector2/V)
			return V ? _x == V._x && _y == V._y : IsZero()

		IsZero()
			return _x == 0 && _y == 0

		Add(vector2/V, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				_x += V._x
				_y += V._y
			else return new /vector2 (_x + V._x, _y + V._y)

		Subtract(vector2/V, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				_x -= V._x
				_y -= V._y
			else return new /vector2 (_x - V._x, _y - V._y)

		Multiply(M, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				if(M)
					_x *= M
					_y *= M
				else
					_x = 0
					_y = 0
			else return M ? new /vector2 (_x * M, _y * M) : VECTOR2_ZERO

		Divide(D, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				_x /= D
				_y /= D
			else return new /vector2 (_x / D, _y / D)

		Scale(S, Vector2Flags/Flags)
			return Multiply(S, Flags)

		Turn(Degrees, Vector2Flags/Flags)
			var c = cos(Degrees)
			var s = sin(Degrees)
			if(Flags & Vector2Flags.Modify)
				var new_x = c * _x - s * _y
				var new_y = s * _x + c * _y
				_x = new_x
				_y = new_y
			else return new /vector2 (c * _x - s * _y, s * _x + c * _y)

		Dampen(vector2/End, T, DeltaTime, Vector2Flags/Flags)
			var end_x, end_y

			if(isnum(End))
				end_x = End
				end_y = End
			else
				end_x = End._x
				end_y = End._y

			if(Flags & Vector2Flags.Modify)
				_x = Math.Dampen(_x, end_x, T, DeltaTime)
				_y = Math.Dampen(_y, end_y, T, DeltaTime)

			else
				var vector2/dampened = new (
					Math.Dampen(_x, end_x, T, DeltaTime),
					Math.Dampen(_y, end_y, T, DeltaTime))

				return dampened

		GetNormalized()
			return (_x || _y) ? Scale(1 / GetMagnitude()) : VECTOR2_ZERO

		GetMagnitude()
			return sqrt(_x * _x + _y * _y)

		GetSquareMagnitude()
			return _x * _x + _y * _y

		GetChebyshevMagnitude()
			return max(abs(_x), abs(_y))

		Dot(vector2/V)
			return _x * V._x + _y * V._y

		ToString()
			return "vector2([_x], [_y])"

		ToText()
			return ToString()

		GetAngle()
			return Directions.FromOffsetToDegrees(_x, _y)
