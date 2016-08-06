#define SealedType(Type) \
Type/New() if(type != .Type) CRASH("Can't extend sealed type."); \
Type
