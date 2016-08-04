#include "Temporary.dm"

ObjectPool
	var
		initial_count
		object_type
	TEMPORARY

	var tmp
		ObjectPool/Poolable/pooled_objects[]

	New(InitialCount, ObjectType)
		if(InitialCount)
			initial_count = InitialCount

		if(ObjectType)
			object_type = ObjectType

		Grow()

	Poolable
		parent_type = /Interface

		EVENT(OnDestroyed, ObjectPool/Poolable/Destroyed)

	proc
		Grow(Count)
			if(isnull(Count))
				Count = initial_count

			log_call(src, "Grow([Count])")

			var start_index

			if(!pooled_objects)
				pooled_objects = new (Count)
				start_index = 1

			else
				start_index = pooled_objects.len + 1
				pooled_objects.len += Count

			for(var/n in start_index to pooled_objects.len)
				var ObjectPool/Poolable/object = new object_type
				pooled_objects[n] = object
				EVENT_ADD(object.OnDestroyed, src, .proc/Push)

		Pop()
			if(!(pooled_objects && pooled_objects.len))
				Grow()

			. = pooled_objects[pooled_objects.len]
			pooled_objects.len--

		Push(ObjectPool/Poolable/Object)
			pooled_objects += Object
