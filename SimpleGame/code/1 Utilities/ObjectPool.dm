#include "Temporary.dm"

ObjectPool
	TEMPORARY

	var
		name = "ObjectPool"

		tmp
			object_type
			growth_count
			ObjectPool/Poolable/pooled_objects[]

	/*
		Creates a new ObjectPool.
	*/
	New(ObjectType, InitialCount, GrowthCount = InitialCount)
		object_type = ObjectType
		growth_count = GrowthCount
		Grow(InitialCount)

	Poolable
		parent_type = /Interface
		EVENT(OnPooled, ObjectPool/Poolable/Object)

	proc
		Grow(Count)
			if(isnull(Count))
				Count = growth_count

			if(!Count)
				return FALSE

			var
				index
				start_index
				end_index
				ObjectPool/Poolable/object

			if(!pooled_objects)
				start_index = 1
				end_index = Count
				pooled_objects = new /list (Count)

			else
				var length = pooled_objects.len
				start_index = 1 + length
				end_index = Count + length
				pooled_objects.len = end_index

			for(index in start_index to end_index)
				object = new object_type
				pooled_objects[index] = object
				EVENT_ADD(object.OnPooled, src, .proc/Push)

			return TRUE

		/*
			Returns an object from the pool.
			If the pool is empty, the pool will grow.
			Returns null if the pool is empty and can't grow.
		*/
		Pop()
			if(!(pooled_objects.len || Grow()))
				return null

			. = pooled_objects[pooled_objects.len]
			pooled_objects.len--

		/*
			Return an object to the pool.
			This is called by the object's OnDestroyed event, which is required for all poolable objects.
		*/
		Push(ObjectPool/Poolable/Object)
			pooled_objects += Object
