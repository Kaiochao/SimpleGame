#include "UpdateLoop.dm"

mob/player
	icon = null

	bounds = "24,24"
	pixel_x = (24 - 32) / 2
	pixel_y = (24 - 32) / 2

	var tmp
		InputHandler/input_handler
		MovementHandler/movement_handler
		AimingHandler/aiming_handler
		Weapon/weapon

		components[]
		component_updaters[]
		component_destroyers[]

		guns[]

	New()
		..()
		update_loop.Add(src)

		var global/obj/body
		if(!body)
			body = new
			var mutable_appearance/a = new (body)
			a.icon_state = "oval"
			a.color = "blue"
			a.transform *= 0.75
			body.appearance = a

		overlays += body

	Del()
		update_loop.Remove(src)
		..()

	Logout()
		Destroy()
		..()

	proc
		Destroy()
			update_loop.Remove(src)
			SetVelocity()
			loc = null
			key = null
			var item, Component/component
			for(item in component_destroyers)
				component = item
				CallComponentDestroy(component)

		AddComponent(Component/Component)
			if(!components)
				components = new

			if(!components[Component])

				components[Component] = TRUE

				if(hascall(Component, "Start"))
					CallComponentStart(Component)

				HasUpdaterComponent(Component)
				HasDestroyerComponent(Component)

		RemoveComponent(Component/Component)
			if(HasComponent(Component))
				components -= Component
				if(!components.len)
					components = null

			if(HasUpdaterComponent(Component))
				component_updaters -= Component
				if(!component_updaters.len)
					component_updaters = null

			if(HasDestroyerComponent(Component))
				component_destroyers -= Component
				if(!component_destroyers.len)
					component_destroyers = null

				CallComponentDestroy(Component)

		HasComponent(Component/Component)
			return components && components[Component]


		HasUpdaterComponent(Component/Component)
			. = component_updaters && component_updaters[Component]
			if(!. && hascall(Component, update_loop.callback))
				if(!component_updaters)
					component_updaters = new
				component_updaters[Component] = TRUE
				return TRUE

		CallComponentUpdate(Component/Component, DeltaTime)
			call(Component, update_loop.callback)(src, DeltaTime)

		Update(update_loop/UpdateLoop, DeltaTime)
			UpdateComponents(DeltaTime)

			if(client)
				winset(src, ":window", "title=\"[world.name] ([world.cpu]%, world.fps: [world.fps])\"")

		UpdateComponents(DeltaTime)
			var global
				item
				Component/component

			for(item in component_updaters)
				component = item
				CallComponentUpdate(component, DeltaTime)


		HasDestroyerComponent(Component/Component)
			. = component_destroyers && component_destroyers[Component]
			if(!. && hascall(Component, "Destroy"))
				if(!component_destroyers)
					component_destroyers = new
				component_destroyers[Component] = TRUE
				return TRUE

		CallComponentDestroy(Component/Component)
			call(Component, "Destroy")(src)


		CallComponentStart(Component/Component)
			call(Component, "Start")(src)


		SetInputHandler(InputHandler/InputHandler)
			input_handler = InputHandler
			if(InputHandler)
				EVENT_ADD(InputHandler.OnMouseWheel, src, .proc/HandleMouseWheel)

		HandleMouseWheel(InputHandler/InputHandler, DeltaX, DeltaY)
			if(DeltaY > 0)
				EquipNextWeapon()
			else
				EquipPreviousWeapon()

		EquipNextWeapon()
			var index = guns.Find(weapon) + 1
			if(index < 1) index = guns.len
			else if(index > guns.len) index = 1
			EquipWeapon(guns[index])

		EquipPreviousWeapon()
			var index = guns.Find(weapon) - 1
			if(index < 1) index = guns.len
			else if(index > guns.len) index = 1
			EquipWeapon(guns[index])


		SetMovementHandler(MovementHandler/MovementHandler)
			movement_handler = MovementHandler
			if(MovementHandler)
				AddComponent(MovementHandler)


		SetAimingHandler(AimingHandler/AimingHandler)
			aiming_handler = AimingHandler
			if(AimingHandler)
				AddComponent(AimingHandler)


		EquipWeapon(Weapon/Weapon)
			if(weapon)
				RemoveComponent(weapon)
			weapon = Weapon
			if(Weapon)
				AddComponent(Weapon)
