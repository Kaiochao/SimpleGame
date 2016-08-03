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
	proc/GetLowerPosition()  return new /Vector2 (GetLowerX(), GetLowerY())

	/* Returns a vector to the center of the bounding box from the world origin.
	*/
	proc/GetCenterPosition() return new /Vector2 (GetCenterX(), GetCenterY())

	/* Sets dir. More useful than setting it directly.
	*/
	proc/SetDirection(Direction)
		if(Direction && Direction != dir)
			dir = Direction

atom/movable
	/* Represent the position within the current whole-pixel position.
		Components are between -0.5 and 0.5.
	*/
	var Vector2/sub_step

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

		switch(args.len)
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

			else CRASH("Unexpected [args.len]-argument form.")

		loc = Loc
		step_x = StepX
		step_y = StepY

		if(StepX || StepY)
			var sub_step_x = StepX - round(StepX, 1)
			var sub_step_y = StepY - round(StepY, 1)
			if(sub_step_x || sub_step_y)
				if(!sub_step)
					sub_step = new (sub_step_x, sub_step_y)
				else
					sub_step.x = sub_step_x
					sub_step.y = sub_step_y

	/* Sets the position of the lower-left corner of src's bounding box.

		Format:
			SetPosition()
				Sends src to the void.

			SetPosition(atom/Atom)
				Aligns src's lower-left with Atom's lower-left.

			SetPosition(Vector2/LowerPosition, Z as num)
				Aligns src's lower-left with the specified position
				on the specified z-level.

			SetPosition(LowerX as num, LowerY as num, Z as num)
				Aligns src's lower-left with the specified coordinates.
				on the specified z-level.

	*/
	proc/SetPosition()
		var LowerX, LowerY, Z

		switch(args.len)
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
				else if(istype(args[1], /Vector2) && isnum(args[2]))
					var Vector2/v = args[1]
					LowerX = v.x
					LowerY = v.y
					Z = args[2]
				else CRASH("Expected 2-argument form: (LowerX as num, LowerY as num) or (Vector2/LowerPosition, Z as num).")

			if(3)
				if(isnum(args[1]) && isnum(args[2]) && isnum(args[3]))
					LowerX = args[1]
					LowerY = args[2]
					Z = args[3]
				else CRASH("Expected 3-argument form: (LowerX as num, LowerY as num, Z as num.")

			else CRASH("Unexpected [args.len]-argument form.")

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

			SetCenter(Vector2/CenterPosition, Z as num)
				Aligns src's center with the specified position
				on the specified z-level.

			SetCenter(CenterX as num, CenterY as num, Z as num)
				Aligns src's center with the specified coordinates.
				on the specified z-level.

	*/
	proc/SetCenter()
		var CenterX, CenterY, Z

		switch(args.len)
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
				else if(istype(args[1], /Vector2) && isnum(args[2]))
					var Vector2/v = args[1]
					CenterX = v.x
					CenterY = v.y
					Z = args[2]
				else CRASH("Expected 2-argument form: (CenterX as num, CenterY as num) or (Vector2/LowerPosition, Z as num).")

			if(3)
				if(isnum(args[1]) && isnum(args[2]) && isnum(args[3]))
					CenterX = args[1]
					CenterY = args[2]
					Z = args[3]
				else CRASH("Expected 3-argument form: (CenterX as num, CenterY as num, Z as num.")

			else CRASH("Unexpected [args.len]-argument form.")

		SetPosition(CenterX - round(bound_width / 2), CenterY - round(bound_height / 2), Z)

	/* Move a certain distance (measured in pixels) along a straight line in the X and Y axes.

		Sub-pixel movements accumulate to become whole-pixel movements.
		Collision is accurate along the straight line of travel.
		Sliding should be handled separately.

		Format:

			Translate(Vector2/Translation)
				Moves by the specified Translation vector in pixels.

			Translate(Tx as num, Ty as num)
				Moves by Tx pixels in the x-axis and Ty pixels in the y-axis.

		Returns:

			An instance of /atom/movable/translate_result that describes
				the results of the translation;

			null if the translation only resulted in at most a sub-pixel shift.

	*/
	proc/Translate()
		var Tx, Ty

		switch(args.len)
			if(0)
				return

			if(1)
				if(istype(args[1], /Vector2))
					var Vector2/vector = args[1]
					Tx = vector.x
					Ty = vector.y
				else CRASH("Expected 1-argument form: (Vector2/Translation)")

			if(2)
				if(isnum(args[1]) && isnum(args[2]))
					Tx = args[1]
					Ty = args[2]
				else CRASH("Expected 2-argument form: (Tx as num, Ty as num)")

			else CRASH("Unexpected [args.len]-argument form.")

		var move_x, move_y

		if(!sub_step)
			sub_step = new

		if(Tx)
			sub_step.x += Tx
			move_x = round(sub_step.x, 1)
			sub_step.x -= move_x

		if(Ty)
			sub_step.y += Ty
			move_y = round(sub_step.y, 1)
			sub_step.y -= move_y

		if(sub_step.IsZero())
			sub_step = null

		if(move_x || move_y)
			var new_step_size = Math.Ceil(max(abs(Tx), abs(Ty)))

			if(step_size != new_step_size)
				step_size = new_step_size

			var start_x = GetCenterX()
			var start_y = GetCenterY()

			Move(loc, dir, step_x + move_x, step_y + move_y)

			var end_x = GetCenterX()
			var end_y = GetCenterY()

			return new .translate_result(
				new /Vector2 (move_x, move_y),
				new /Vector2 (end_x - start_x, end_y - start_y)
			)

atom/movable/translate_result
	parent_type = /datum

	var
		Vector2
			// How far the translation could have gone, in whole pixels.
			tried

			// How far the translation ended up going, in whole pixels.
			moved

		/* Direction bits of bumped-ness.
			e.g. 	if Translate(new /Vector2 (5, 5)) resulted in a bump
					from the north but not the east,
						then bump_dir will be NORTH.
		*/
		bump_dir = 0

	New(Vector2/Tried, Vector2/Moved)
		tried = Tried
		moved = Moved

		if(Tried.x && abs(Tried.x) > abs(Moved.x))
			if(Tried.x > 0)
				bump_dir |= EAST
			else
				bump_dir |= WEST

		if(Tried.y && abs(Tried.y) > abs(Moved.y))
			if(Tried.y > 0)
				bump_dir |= NORTH
			else
				bump_dir |= SOUTH
