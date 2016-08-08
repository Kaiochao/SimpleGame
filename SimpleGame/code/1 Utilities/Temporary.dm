/* Modifies a type that must not be saved or loaded.
Causes Read() and Write() to crash (by default).
Must be placed on a line by itself.
*/
#define TEMPORARY \
Read() CRASH("[type] is temporary."); \
Write() CRASH("[type] is temporary.")
