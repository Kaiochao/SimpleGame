#define AbstractType(Type) Type/New() { if(type == .Type) CRASH("Can't instantiate abstract type."); ..() }; Type
