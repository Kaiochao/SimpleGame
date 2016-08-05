AbstractType(Component/WeaponHandler)
	var
		Component/Weapon
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
	proc/SetWeapons(Component/Weapon/Weapons[])
		_weapons = Weapons.Copy()

	proc/EquipWeapon(Component/Weapon/Weapon)
		if(_weapon)
			entity.RemoveComponent(_weapon)
		_weapon = Weapon
		if(Weapon)
			entity.AddComponent(Weapon)
