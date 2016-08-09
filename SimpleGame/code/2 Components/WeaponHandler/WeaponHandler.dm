AbstractType(Component/WeaponHandler)
	var
		Component/Weapon
			_weapon
			_weapons[]

	var tmp
		_is_using

	EVENT(StartedUsing, Component/WeaponHandler/WeaponHandler)
	EVENT(StoppedUsing, Component/WeaponHandler/WeaponHandler)

	proc
		/* Returns the Weapon currently equipped.
		*/
		GetWeapon()
			return _weapon

		/* Sets weapons to the given array.
		*/
		SetWeapons(Component/Weapon/Weapons[])
			_weapons = Weapons.Copy()

		/* Equips a weapon.
		If Weapon is a number N, the N'th available weapon is equipped.
		*/
		EquipWeapon(Component/Weapon/Weapon)
			if(_weapon)
				entity.RemoveComponent(_weapon)
			if(isnum(Weapon))
				var weapon_count = length(_weapons)
				if(weapon_count > 0)
					while(Weapon < 1) Weapon += weapon_count
					while(Weapon > weapon_count) Weapon -= weapon_count
					Weapon = _weapons[Weapon]
				else Weapon = null
			_weapon = Weapon
			if(Weapon)
				entity.AddComponent(Weapon)

		/* Is the weapon being used? e.g. the gun's trigger is being pulled
		*/
		IsUsing()
			return _is_using

		/* Set whether the weapon is being used.
		*/
		SetUsing(Value)
			if(_is_using != Value)
				_is_using = Value
				if(Value)
					StartedUsing()
				else
					StoppedUsing()

		/* Equips the next available weapon.
		*/
		EquipNextWeapon()
			if(!length(_weapons))
				return

			if(!_weapon)
				EquipWeapon(1)
				return

			EquipWeapon(_weapons.Find(_weapon) + 1)

		/* Equips the available weapon previous to the one currently equipped.
		*/
		EquipPreviousWeapon()
			if(!length(_weapons))
				return

			if(!_weapon)
				EquipWeapon(1)
				return

			EquipWeapon(_weapons.Find(_weapon) - 1)
