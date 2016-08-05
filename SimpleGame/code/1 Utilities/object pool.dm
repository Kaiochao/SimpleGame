#include "Temporary.dm"

object_pool
	TEMPORARY

	var
		name = "object pool"

		object_type
		initial_count
		growth_count
		object_pool/Poolable/pooled_objects[]

	New(ObjectType, InitialCount, GrowthCount = InitialCount)
		if(!isnull(ObjectType))
			object_type = ObjectType
		if(!isnull(InitialCount))
			initial_count = InitialCount
		if(!isnull(GrowthCount))
			growth_count = GrowthCount
		Grow(initial_count)

	Poolable
		parent_type = /Interface
		EVENT(OnPooled, object_pool/Poolable/Object)
		EVENT(OnUnpooled, object_pool/Poolable/Object)

	proc/Instantiate()
		return new object_type

	/*
		Returns an object from the pool.
		If the pool is empty, the pool will grow.
		Returns null if the pool is empty and can't grow.
	*/
	proc/Pop()
		if(!(pooled_objects.len || Grow()))
			return null

		var object_pool/Poolable/object = pooled_objects[pooled_objects.len]
		pooled_objects.len--

		object.OnUnpooled()

		return object

	/*
		Return an object to the pool.
		This is called by the object's OnDestroyed event, which is required for all poolable objects.
	*/
	proc/Push(object_pool/Poolable/Object)
		if(!pooled_objects[Object])
			pooled_objects[Object] = TRUE

	proc/Grow(Count)
		if(isnull(Count))
			Count = growth_count

		if(!Count)
			return FALSE

		var
			index
			start_index
			end_index
			object_pool/Poolable/object

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
			object = Instantiate()
			pooled_objects[index] = object
			pooled_objects[object] = TRUE
			EVENT_ADD(object.OnPooled, src, .proc/Push)

		return TRUE
