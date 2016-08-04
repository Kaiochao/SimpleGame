#ifdef DEBUG
proc
	log_call(datum/Object, Message)
		world.log << "\ref[Object] \"[Object]\" [Message]"
#else
#define log_call(a, b)
#endif
