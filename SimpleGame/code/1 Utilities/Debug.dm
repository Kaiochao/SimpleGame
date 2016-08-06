#define object_to_debug_text(Object) "\"[Object]\" ([Object.type] \ref[Object])"
#ifdef DEBUG
#define log_call(Object, Message) world.log << "CALL (time: [world.time]): [object_to_debug_text(Object)] [Message]"
#define log_warning(Message) world.log << "[__FILE__]:[__LINE__] warning: [Message]"
#else
#define log_call(Object, Message)
#define log_warning(Message)
#endif
