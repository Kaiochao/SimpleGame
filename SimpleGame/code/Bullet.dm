#include "Physics.dm"
#include "Player.dm"
#include "Gun.dm"

Bullet
	parent_type = /obj

	mouse_opacity = FALSE

	icon_state = "oval"
	color = "yellow"

	density = TRUE
	bounds = "1,1"
	pixel_x = (1 - 32) / 2
	pixel_y = (1 - 32) / 2
	transform = matrix(3/32, 0, 0, 0, 9/32, 0)

	var
		minimum_speed = 100
		drag = 1

	var tmp
		initial_speed

	EVENT(OnDestroyed, Bullet/Bullet)

	Cross(Bullet/Bullet)
		return istype(Bullet) || ..()

	Translate(Vector2/V)
		. = ..()
		var atom/movable/translate_result/result = .
		if(!result || result.bump_dir)
			Destroy()

	PhysicsUpdate(UpdateLoop/Physics/PhysicsLoop, DeltaTime)
		var speed_squared = velocity && velocity.GetSquareMagnitude()

		if(speed_squared < minimum_speed * minimum_speed)
			Destroy()

		else
			var Vector2/dampened_velocity = velocity.Dampen(0, drag, DeltaTime)
			SetVelocity(dampened_velocity)

			var speed = sqrt(speed_squared)
			alpha = speed / initial_speed * (256 - 224) + 224

	proc
		Destroy()
			loc = null

			if(OnDestroyed)
				OnDestroyed(src)

		Go(Gun/Gun)
			alpha = initial(alpha)
			drag = initial(drag)
			minimum_speed = initial(minimum_speed)

			var
				mob/player/player = Gun.equipper

				Vector2
					muzzle_position = Gun.GetMuzzlePosition()
					player_position = player.GetCenterPosition()
					to_muzzle = muzzle_position.Subtract(player_position)
					muzzle_velocity = Gun.GetMuzzleVelocity()

			transform = initial(transform) * Math.RotationMatrix(muzzle_velocity.GetNormalized())
			initial_speed = muzzle_velocity.GetMagnitude()

			SetCenter(player)
			Translate(to_muzzle)

			SetVelocity(muzzle_velocity)
