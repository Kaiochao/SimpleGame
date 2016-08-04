#include "Cooldown.dm"
#include <Kaiochao\InputHandler\InputHandler.dme>

Gun
	parent_type = /Weapon

	var global
		ObjectPool/BulletPool = new (10, /Bullet)

	var
		muzzle_speed = 1600
		body_length = 32

	var tmp
		Cooldown/shot_cooldown = new (1)
		mouse_downed

	Update(mob/player/Player, DeltaTime)
		..()
		if(CanShoot(Player))
			mouse_downed = FALSE
			shot_cooldown.Start()
			Shoot()

	Start(mob/player/Player)
		..()
		EVENT_ADD(Player.input_handler.OnButton, src, .proc/HandleButton)

	Destroy(mob/player/Player)
		..()
		EVENT_REMOVE(Player.input_handler.OnButton, src, .proc/HandleButton)

	proc
		CanShoot(mob/player/Player)
			if(shot_cooldown && shot_cooldown.IsCoolingDown())
				return FALSE

			if(mouse_downed)
				return TRUE

			if(Player.input_handler && Player.input_handler.GetButtonState(Macro.MouseLeftButton))
				return TRUE

			return FALSE

		HandleButton(InputHandler/InputHandler, Macro/Macro, ButtonState/ButtonState)
			if(ButtonState == ButtonState.Pressed && Macro == Macro.MouseLeftButton)
				mouse_downed = TRUE

		Shoot()
			var Bullet/bullet = BulletPool.Pop()
			bullet.Go(src)
			return bullet

		GetDirection()
			var mob/player/player = equipper
			return player.aiming_handler.GetDirection()

		GetMuzzlePosition()
			var mob/player/player = equipper
			var Vector2/muzzle_position = player.aiming_handler.GetDirection()
			muzzle_position.Scale(body_length, Vector2Flags.Modify)
			muzzle_position.Add(equipper.GetCenterPosition(), Vector2Flags.Modify)
			return muzzle_position

		GetMuzzleVelocity()
			var Vector2/muzzle_velocity = GetDirection()
			muzzle_velocity = muzzle_velocity.Scale(muzzle_speed)
			return muzzle_velocity

Gun/Inaccurate
	var
		inaccuracy = 2

	GetDirection()
		var Vector2/direction = ..()
		return direction.Turn(pick(1, -1) * inaccuracy * (2 * rand() - 1) ** 2)

Gun/Spread
	parent_type = /Gun/Inaccurate

	inaccuracy = 10
	shot_cooldown = new (3)

	Shoot()
		for(var/n in 1 to 7)
			var Bullet/bullet = ..()

			bullet.drag = 2
			bullet.minimum_speed = 300

			var s = 1 - rand() * 0.3
			bullet.SetVelocity(bullet.velocity.Scale(s))
