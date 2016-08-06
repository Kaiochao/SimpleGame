#define DEBUG_OBJECT_TEXT(Object) "\"[Object]\" ([Object.type] \ref[Object])"
#ifdef DEBUG
#define DEBUG_CALL(Object, Message) world.log << "CALL (time: [world.time]): [DEBUG_OBJECT_TEXT(Object)] [Message]"
#define DEBUG_WARN(Message) world.log << "[__FILE__]:[__LINE__] warning: [Message]"
#else
#define DEBUG_CALL(Object, Message)
#define DEBUG_WARN(Message)
#endif
