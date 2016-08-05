AbstractType(WeaponHandler)
	parent_type = /Component

	var
		Weapon
			_weapon
			_weapons[]

	/*
		Returns the /Weapon instance currently equipped.
	*/
	proc/GetWeapon()
		return _weapon

	/*
		Returns an array of available weapons.
	*/
	proc/GetWeapons()
		return _weapons

	/*
		Sets weapons to the given array.
	*/
	proc/SetWeapons(Weapon/Weapons[])
		_weapons = Weapons.Copy()

	proc/EquipWeapon(Weapon/Weapon)
		if(_weapon)
			entity.RemoveComponent(_weapon)
		_weapon = Weapon
		if(Weapon)
			entity.AddComponent(Weapon)
