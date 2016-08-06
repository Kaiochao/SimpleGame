#include "Temporary.dm"

StaticType(ObjectPool)
	proc
		Pop(object_pool/Pool, ObjectType)
			if(Pool)
				return Pool.Pop(ObjectType)

		Push(object_pool/Pool, object_pool/Poolable/Object)
			if(!Pool)
				return FALSE
			Pool.Push(Object)
			return TRUE

// A test pool that just doesn't pool anything.
object_pool/disabled
	Pop()
		var object_pool/Poolable/object = Instantiate()
		object.Unpooled(src)
		return object

	Push(object_pool/Poolable/Object)
		Object.Pooled(src)

	Grow(Count)

object_pool
	TEMPORARY

	var
		name = "object pool"

		object_type
		initial_count
		growth_count
		object_pool/Poolable/pooled_objects[]

		push_on_instantiation = FALSE

	New(ObjectType, InitialCount, GrowthCount = InitialCount)
		if(!isnull(ObjectType)) object_type = ObjectType
		if(!isnull(InitialCount)) initial_count = InitialCount
		if(!isnull(GrowthCount)) growth_count = GrowthCount
		if(initial_count) Grow(initial_count)

	proc
		/*
			Returns, by default, a new instance of object_type.
		*/
		Instantiate()
			return new object_type

		/*
			Returns:
			* An object of type object_type from the pool.
			* null if the pool is empty and can't grow.

			If the pool is empty, the pool will grow.
			The object's OnUnpooled() event is fired.
		*/
		Pop(ObjectType)
			if(isnull(ObjectType)) ObjectType = object_type

			var pooled_objects_length = length(pooled_objects)

			if(!(pooled_objects_length || Grow()))
				return null

			var object_pool/Poolable/object = locate(ObjectType
				) in pooled_objects

			if(!object)
				world.log << "Pooled objects: \n* [jointext(pooled_objects, "\n* ", 1, 3)]"
				CRASH("Failed to locate [ObjectType] in pooled objects.")

			pooled_objects -= object

			object.Unpooled(src)

			return object

		/*
			Moves an object back to the pool.
		*/
		Push(object_pool/Poolable/Object)
			if(!pooled_objects[Object])
				pooled_objects[Object] = TRUE
				Object.Pooled(src)

		/*
			Instantiates and adds [Count] more objects to the pool.
		*/
		Grow(Count)
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
				var length = length(pooled_objects)
				start_index = 1 + length
				end_index = Count + length
				pooled_objects.len = end_index

			for(index in start_index to end_index)
				object = Instantiate()
				pooled_objects[index] = object
				pooled_objects[object] = TRUE

			return TRUE


	InterfaceType(Poolable)
		proc
			/*
				Called by ObjectPool when the object is added to the pool.
			*/
			Pooled(object_pool/ObjectPool)

			/*
				Called by ObjectPool when the object is removed from the pool.
			*/
			Unpooled(object_pool/ObjectPool)

			/*
				Should return the object pool that owns this object.
			*/
			GetObjectPool()
