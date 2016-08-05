AbstractType(Component/Wrapper)
	var tmp/_value

	proc/Get()
		return _value

	proc/Set(Value)
		_value = Value

Entity
	proc/GetWrappedValue(WrapperType)
		var Component/Wrapper/wrapper = GetComponent(WrapperType)
		return wrapper ? wrapper.Get() : null

Component
	proc/GetWrappedValue(WrapperType)
		return entity.GetWrappedValue(WrapperType)
