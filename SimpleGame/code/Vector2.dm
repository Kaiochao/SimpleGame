#include <Kaiochao\Enum\Enum.dme>

#define VECTOR2_ZERO (new /Vector2 (0, 0))

ENUM(Vector2Flags)
	Modify = 1

var Vector2Static/Vector2 = new

Vector2Static
	proc
		FromList(List[])
			return new /Vector2 (List[1], List[2])

Vector2/Immutable
	var
		name

	New(X = 0, Y = 0)
		..()
		name = "Vector2([X], [Y])"

	proc
		FailChange()
			CRASH("Attempted to change immutable vector.")

	Add(Vector2/V, Vector2Flags/Flags)
		if(Flags & Vector2Flags.Modify)
			FailChange()
		else
			return new /Vector2 (x + V.x, y + V.y)

	Subtract(Vector2/V, Vector2Flags/Flags)
		if(Flags & Vector2Flags.Modify)
			FailChange()
		else
			return new /Vector2 (x - V.x, y - V.y)

	Multiply(M, Vector2Flags/Flags)
		if(Flags & Vector2Flags.Modify)
			FailChange()
		else
			return M ? new /Vector2 (x * M, y * M) : VECTOR2_ZERO

	Divide(D, Vector2Flags/Flags)
		if(Flags & Vector2Flags.Modify)
			FailChange()
		else
			return new /Vector2 (x / D, y / D)

	Scale(S, Vector2Flags/Flags)
		return Multiply(S, Flags)

	GetNormalized()
		return (x || y) ? Scale(1 / GetMagnitude()) : VECTOR2_ZERO

	GetMagnitude()
		return sqrt(x * x + y * y)

	GetSquareMagnitude()
		return x * x + y * y

	GetChebyshevMagnitude()
		return max(abs(x), abs(y))

	Dot(Vector2/V)
		return x * V.x + y * V.y

	IsZero()
		return x == 0 && y == 0

	ToString()
		return name

	ToText()
		return name

	GetAngle()
		return Directions.FromOffsetToDegrees(x, y)

	Turn(Degrees)
		var c = -cos(Degrees)
		var s = sin(Degrees)
		return new /Vector2 (c * x - s * y, s * x + c * y)

	Dampen(Vector2/End, T, DeltaTime, Vector2Flags/Flags)
		var end_x, end_y

		if(isnum(End))
			end_x = End
			end_y = End
		else
			end_x = End.x
			end_y = End.y

		if(Flags & Vector2Flags.Modify)
			FailChange()

		else
			var Vector2/dampened = new (
				Math.Dampen(x, end_x, T, DeltaTime),
				Math.Dampen(y, end_y, T, DeltaTime))

			return dampened

Vector2
	var
		x
		y

	New(X = 0, Y = 0)
		if(isnum(X) && isnum(Y))
			x = X
			y = Y
		else CRASH("Unexpected argument form.")

	proc
		CopyToImmutable()
			return new /Vector2/Immutable (x, y)

		Copy()
			return new /Vector2 (x, y)

		Equals(Vector2/V)
			return V ? x == V.x && y == V.y : IsZero()

		Add(Vector2/V, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				x += V.x
				y += V.y
			else
				return new /Vector2 (x + V.x, y + V.y)

		Subtract(Vector2/V, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				x -= V.x
				y -= V.y
			else
				return new /Vector2 (x - V.x, y - V.y)

		Multiply(M, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				if(M)
					x *= M
					y *= M
				else
					x = 0
					y = 0
			else
				return M ? new /Vector2 (x * M, y * M) : VECTOR2_ZERO

		Divide(D, Vector2Flags/Flags)
			if(Flags & Vector2Flags.Modify)
				x /= D
				y /= D
			else
				return new /Vector2 (x / D, y / D)

		Scale(S, Vector2Flags/Flags)
			return Multiply(S, Flags)

		GetNormalized()
			return (x || y) ? Scale(1 / GetMagnitude()) : VECTOR2_ZERO

		GetMagnitude()
			return sqrt(x * x + y * y)

		GetSquareMagnitude()
			return x * x + y * y

		GetChebyshevMagnitude()
			return max(abs(x), abs(y))

		Dot(Vector2/V)
			return x * V.x + y * V.y

		IsZero()
			return x == 0 && y == 0

		ToString()
			return "Vector2([x], [y])"

		ToText()
			return ToString()

		GetAngle()
			return Directions.FromOffsetToDegrees(x, y)

		Turn(Degrees)
			var c = cos(Degrees)
			var s = sin(Degrees)
			return new /Vector2 (c * x - s * y, s * x + c * y)

		Dampen(Vector2/End, T, DeltaTime, Vector2Flags/Flags)
			var end_x, end_y

			if(isnum(End))
				end_x = End
				end_y = End
			else
				end_x = End.x
				end_y = End.y

			if(Flags & Vector2Flags.Modify)
				x = Math.Dampen(x, end_x, T, DeltaTime)
				y = Math.Dampen(y, end_y, T, DeltaTime)

			else
				var Vector2/dampened = new (
					Math.Dampen(x, end_x, T, DeltaTime),
					Math.Dampen(y, end_y, T, DeltaTime))

				return dampened
