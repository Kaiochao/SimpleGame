/*

	Map Initialization module!

	Setup:
		* In world/New(), call InitializeMap().
		* In atom/New(), call CheckMapInitialization().
		* Override the atom.can_map_initialize property to return TRUE for
		atoms that should have their MapInitialize() called.

	Usage:
		Override atom/MapInitialize() to add behavior that occurs either:
		* On map initialization, which happens automatically at world startup.
		* When the atom is initialized, if created after world startup.

*/

var
	_is_map_initialized = FALSE

world
	proc/InitializeMap()
		if(_is_map_initialized) return
		_is_map_initialized = TRUE
		for(var/atom/a)
			if(a.can_map_initialize)
				a.can_map_initialize = FALSE
				a.MapInitialize()

atom
	var tmp
		can_map_initialize = FALSE

	proc/CheckMapInitialization()
		if(can_map_initialize && !_is_map_initialized)
			can_map_initialize = FALSE
			MapInitialize()

	// For overriding.
	proc/MapInitialize()