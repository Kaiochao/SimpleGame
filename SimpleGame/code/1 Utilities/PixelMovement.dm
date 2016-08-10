#include "Vector2.dm"

/*

This file includes extensions to /atom and /atom/movable that make pixel movement more seamless
(i.e. less dependence on tile-based things).

*/

atom
	/* Returns the pixel-x-coordinate of the lower-left corner of the bounding box.
	*/
	proc/GetLowerX()  return 1 + (x - 1) * TILE_WIDTH

	/* Returns the pixel-y-coordinate of the lower-left corner of the bounding box.
	*/
	proc/GetLowerY()  return 1 + (y - 1) * TILE_HEIGHT

	/* Returns the pixel-x-coordinate of the center of the bounding box.
	*/
	proc/GetCenterX() return 1 + (x - 0.5) * TILE_WIDTH

	/* Returns the pixel-y-coordinate of the center of the bounding box.
	*/
	proc/GetCenterY() return 1 + (y - 0.5) * TILE_HEIGHT

	/* Returns a vector to the bottom-left of the bounding box from the world origin.
	*/
	proc/GetLowerPosition()  return new /vector2 (GetLowerX(), GetLowerY())

	/* Returns a vector to the center of the bounding box from the world origin.
	*/
	proc/GetCenterPosition() return new /vector2 (GetCenterX(), GetCenterY())

	/* Sets dir. More useful than setting it directly.
	*/
	proc/SetDirection(Direction)
		if(Direction && Direction != dir)
			dir = Direction

atom/movable
	/* Represent the position within the current whole-pixel position.
		Components are between -0.5 and 0.5.
	*/
	var vector2/_sub_step

	proc/SetSubStep(X, Y)
		if(X || Y)
			_sub_step = new /vector2 (X, Y)
		else
			_sub_step = null

	proc/GetSubStep()
		return _sub_step

	GetLowerX()  return 1 + bound_x + step_x + (x - 1) * TILE_WIDTH
	GetLowerY()  return 1 + bound_y + step_y + (y - 1) * TILE_HEIGHT
	GetCenterX() return 1 + bound_x + step_x + (x - 1) * TILE_WIDTH  + bound_width  / 2
	GetCenterY() return 1 + bound_y + step_y + (y - 1) * TILE_HEIGHT + bound_height / 2

	/* Sets loc, step_x, and step_y. More useful than setting them directly.

		Format:
			SetLocation()
				Sets loc to null.

			SetLocation(atom/Loc)
				Sets loc to Loc; step_x and step_y are set to 0.

			SetLocation(atom/Loc, StepX, StepY)
				set loc, step_x, and step_y to Loc, StepX, and StepY, respectively.

	*/
	proc/SetLocation()
		var atom/Loc, StepX, StepY

		switch(length(args))
			if(0)

			if(1)
				if(isloc(args[1]))
					Loc = args[1]
				else CRASH("Expected 1-argument form: (atom/Loc)")

			if(3)
				if(isloc(args[1]) && isnum(args[2]) && isnum(args[3]))
					Loc = args[1]
					StepX = args[2]
					StepY = args[3]
				else CRASH("Expected 3-argument form: (atom/Loc, StepX, StepY)")

			else CRASH("Unexpected [length(args)]-argument form.")

		loc = Loc
		step_x = StepX
		step_y = StepY

		if(StepX || StepY)
			SetSubStep(StepX - round(StepX, 1), StepY - round(StepY, 1))

	/* Sets the position of the lower-left corner of src's bounding box.

		Format:
			SetPosition()
				Sends src to the void.

			SetPosition(atom/Atom)
				Aligns src's lower-left with Atom's lower-left.

			SetPosition(vector2/LowerPosition, Z as num)
				Aligns src's lower-left with the specified position
				on the specified z-level.

			SetPosition(LowerX as num, LowerY as num, Z as num)
				Aligns src's lower-left with the specified coordinates.
				on the specified z-level.

	*/
	proc/SetPosition()
		var LowerX, LowerY, Z

		switch(length(args))
			if(0)
				SetLocation()

			if(1)
				if(isloc(args[1]))
					var atom/a = args[1]
					LowerX = a.GetLowerX()
					LowerY = a.GetLowerY()
					Z = a.z
				else CRASH("Expected 1-argument form: (atom/Atom)")

			if(2)
				if(isnum(args[1]) && isnum(args[2]))
					LowerX = args[1]
					LowerY = args[2]
					Z = z
				else if(istype(args[1], /vector2) && isnum(args[2]))
					var vector2/v = args[1]
					LowerX = v.GetX()
					LowerY = v.GetY()
					Z = args[2]
				else CRASH("Expected 2-argument form: (LowerX as num, LowerY as num) or (vector2/LowerPosition, Z as num).")

			if(3)
				if(isnum(args[1]) && isnum(args[2]) && isnum(args[3]))
					LowerX = args[1]
					LowerY = args[2]
					Z = args[3]
				else CRASH("Expected 3-argument form: (LowerX as num, LowerY as num, Z as num.")

			else CRASH("Unexpected [length(args)]-argument form.")

		var
			new_tile_x = -round(LowerX / -TILE_WIDTH)
			new_tile_y = -round(LowerY / -TILE_HEIGHT)
			new_step_x = round(LowerX) - bound_x - (new_tile_x - 1) * TILE_WIDTH  - 1
			new_step_y = round(LowerY) - bound_y - (new_tile_y - 1) * TILE_HEIGHT - 1

		if(new_tile_x < 1)
			new_step_x += (new_tile_x - 1) * TILE_WIDTH
			new_tile_x = 1

		else if(new_tile_x > world.maxx)
			new_step_x -= (world.maxx - new_tile_x) * TILE_WIDTH
			new_tile_x = world.maxx

		if(new_tile_y < 1)
			new_step_y += (new_tile_y - 1) * TILE_HEIGHT
			new_tile_y = 1

		else if(new_tile_y > world.maxy)
			new_step_y -= (world.maxy - new_tile_y) * TILE_HEIGHT
			new_tile_y = world.maxy

		SetLocation(locate(new_tile_x, new_tile_y, Z), new_step_x, new_step_y)

	/* Sets the position of the center of src's bounding box.

		Format:

			SetCenter()
				Sends src to the void.

			SetCenter(atom/Atom)
				Aligns src's center with Atom's center.

			SetCenter(vector2/CenterPosition, Z as num)
				Aligns src's center with the specified position
				on the specified z-level.

			SetCenter(CenterX as num, CenterY as num, Z as num)
				Aligns src's center with the specified coordinates.
				on the specified z-level.

	*/
	proc/SetCenter()
		var CenterX, CenterY, Z

		switch(length(args))
			if(0)
				SetLocation()

			if(1)
				if(isloc(args[1]))
					var atom/a = args[1]
					CenterX = a.GetCenterX()
					CenterY = a.GetCenterY()
					Z = a.z
				else CRASH("Expected 1-argument form: (atom/Atom)")

			if(2)
				if(isnum(args[1]) && isnum(args[2]))
					CenterX = args[1]
					CenterY = args[2]
					Z = z
				else if(istype(args[1], /vector2) && isnum(args[2]))
					var vector2/v = args[1]
					CenterX = v.GetX()
					CenterY = v.GetY()
					Z = args[2]
				else CRASH("Expected 2-argument form: (CenterX as num, CenterY as num) or (vector2/LowerPosition, Z as num).")

			if(3)
				if(isnum(args[1]) && isnum(args[2]) && isnum(args[3]))
					CenterX = args[1]
					CenterY = args[2]
					Z = args[3]
				else CRASH("Expected 3-argument form: (CenterX as num, CenterY as num, Z as num.")

			else CRASH("Unexpected [length(args)]-argument form.")

		SetPosition(CenterX - round(bound_width / 2), CenterY - round(bound_height / 2), Z)

	/* Move a certain distance (measured in pixels) along a straight line in the X and Y axes.

		Sub-pixel movements accumulate to become whole-pixel movements.
		Collision is accurate along the straight line of travel.
		Sliding should be handled separately.

		Format:

			Translate(vector2/Translation)
				Moves by the specified Translation vector in pixels.

			Translate(Tx as num, Ty as num)
				Moves by Tx pixels in the x-axis and Ty pixels in the y-axis.

		Returns:

			An instance of /atom/movable/translate_result that describes
				the results of the translation;

			null if the translation only resulted in at most a sub-pixel shift.

	*/

	proc/Translate(vector2/V, TranslateFlags/Flags)
		return TranslateXY(V.GetX(), V.GetY(), Flags)

	proc/TranslateXY(X, Y, TranslateFlags/Flags)
		var
			vector2/sub_step = GetSubStep()
			sub_step_x
			sub_step_y
			move_x
			move_y

		if(sub_step)
			sub_step_x = sub_step.GetX()
			sub_step_y = sub_step.GetY()
		else
			sub_step_x = 0
			sub_step_y = 0

		if(X)
			sub_step_x += X
			move_x = round(sub_step_x, 1)
			sub_step_x -= move_x

		if(Y)
			sub_step_y += Y
			move_y = round(sub_step_y, 1)
			sub_step_y -= move_y

		SetSubStep(sub_step_x, sub_step_y)

		if(move_x || move_y)
			var new_step_size = 1 + Math.Ceil(max(abs(X), abs(Y)))

			if(step_size != new_step_size)
				step_size = new_step_size

			var
				start_x = GetCenterX()
				start_y = GetCenterY()

			if(!(Flags & TranslateFlags.EnableSliding) || new_step_size > bound_width && new_step_size > bound_height)
				Move(loc, dir, step_x + move_x, step_y + move_y)

			else
				var
					new_loc = loc
					new_dir = dir
					old_step_x = step_x
					old_step_y = step_y
					new_step_x = old_step_x + move_x
					new_step_y = old_step_y + move_y

				if(!Move(new_loc, new_dir, new_step_x, new_step_y))
					if(!Move(new_loc, new_dir, new_step_x, old_step_y))
						Move(new_loc, new_dir, old_step_x, new_step_y)
					Move(new_loc, new_dir, new_step_x, new_step_y)

			var
				end_x = GetCenterX()
				end_y = GetCenterY()

			return new .translate_result(
				new /vector2 (move_x, move_y),
				new /vector2 (end_x - start_x, end_y - start_y)
			)

ENUM(TranslateFlags)
	EnableSliding = 1

atom/movable/translate_result
	parent_type = /datum

	var
		vector2
			// How far the translation could have gone, in whole pixels.
			tried

			// How far the translation ended up going, in whole pixels.
			moved

		/* Direction bits of bumped-ness.
			e.g. 	if Translate(new /vector2 (5, 5)) resulted in a bump
					from the north but not the east,
						then bump_dir will be NORTH.
		*/
		bump_dir = 0

	New(vector2/Tried, vector2/Moved)
		tried = Tried
		moved = Moved

		var
			tried_x = Tried.GetX()
			tried_y = Tried.GetY()

		if(tried_x && abs(tried_x) > abs(Moved.GetX()))
			if(tried_x > 0)
				bump_dir |= EAST
			else
				bump_dir |= WEST

		if(tried_y && abs(tried_y) > abs(Moved.GetY()))
			if(tried_y > 0)
				bump_dir |= NORTH
			else
				bump_dir |= SOUTH
