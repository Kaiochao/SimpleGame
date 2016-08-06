#define StaticType(Type) \
var global/Static/Type/Type = new /Static/Type; \
Static/Type/New() {\
	var global/instantiated = FALSE; \
	if(instantiated) CRASH("Can't instantiate static type."); \
	instantiated = TRUE; \
}; \
Static/Type
