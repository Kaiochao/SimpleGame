#ifdef DEBUG
#define log_call(Object, Message) world.log << "\ref[Object] \"[Object]\" [Message]"
#define log_warning(Message) world.log << "[__FILE__]:[__LINE__] warning: [Message]"
#else
#define log_call(Object, Message)
#define log_warning(Message)
#endif
