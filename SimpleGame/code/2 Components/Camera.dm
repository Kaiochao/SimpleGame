Component/camera
	var
		// Target position
		x = 0
		y = 0

		// Speed to get to the target position
		speed = 1#INF

		// If the camera is this many pixels away from the entity,
		// jump to the entity instead of moving gradually.
		jump_threshold = 640

		_attached = TRUE

	var tmp
		client/_client
		obj/_anchor = new
		Entity/_target
		_last_x
		_last_y

	proc
		SetAttached(Value)
			_attached = Value

		IsAttached()
			return _attached

		SetTarget(Entity/Target)
			_target = Target

		SetPosition(X, Y)
			x = X
			y = Y

		SetClient(client/Client)
			if(Client)
				Client.perspective = EYE_PERSPECTIVE
				Client.eye = _anchor
				_client = Client

		Start()
			SetClient(entity.GetWrappedValue(/Component/Wrapper/client))
			SetTarget(entity)
			SetAttached(TRUE)

		Destroy()
			SetTarget()

			if(_client)
				_client.eye = _client.mob
				_client.perspective = initial(_client.perspective)
				_client = null

			_anchor.loc = null
			_anchor = null

		LateUpdate()
			if(IsAttached())
				if(!_target || _target.IsDestroyed())
					SetTarget()
				else
					SetPosition(_target.GetCenterX(), _target.GetCenterY())

			var
				delta_time = entity.update_loop.delta_time
				X = Math.Dampen(_last_x, x, speed, delta_time)
				Y = Math.Dampen(_last_y, y, speed, delta_time)
				adx = Math.Ceil(abs(X - _last_x))
				ady = Math.Ceil(abs(Y - _last_y))
				step_size = max(adx, ady)

			if(step_size)
				_anchor.step_size = step_size
				if(jump_threshold < abs(x - _last_x) || jump_threshold < abs(y - _last_y))
					_last_x = x
					_last_y = y
				else
					_last_x = X
					_last_y = Y
				_anchor.SetCenter(_last_x, _last_y, entity.z)
