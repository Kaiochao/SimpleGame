AbstractType(WeaponHandler)
	parent_type = /Component

	var
		Weapon/_weapon
		_weapons[]

	proc
		/*
			Returns the /Weapon instance currently equipped.
		*/
		GetWeapon()
			return _weapon

		/*
			Returns an array of available guns.
		*/
		GetWeapons()
			return _weapons

		/*
			Sets guns to the given args array.
		*/
		SetWeapons(Weapon/Weapons[])
			_weapons = Weapons.Copy()

		EquipWeapon(Weapon/Weapon)
			if(_weapon)
				player.RemoveComponent(_weapon)
			_weapon = Weapon
			if(Weapon)
				player.AddComponent(Weapon)
