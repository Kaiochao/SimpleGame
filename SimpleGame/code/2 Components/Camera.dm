Component/camera
	var
		// Target position
		x = 0
		y = 0

		// Speed to get to the target position
		speed = 1#INF

		// If the camera is this many pixels away from the entity,
		// jump to the entity instead of moving gradually.
		jump_threshold = 100

	var tmp
		client/_client
		obj/_anchor = new
		_last_x
		_last_y

	proc
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

		Destroy()
			if(_client)
				_client.eye = _client.mob
				_client.perspective = initial(_client.perspective)
				_client = null

			_anchor.loc = null
			_anchor = null

		LateUpdate()
			var
				X = Math.Dampen(_last_x, x, speed, Time.delta_time)
				Y = Math.Dampen(_last_y, y, speed, Time.delta_time)
				adx = Math.Ceil(abs(X - _last_x))
				ady = Math.Ceil(abs(Y - _last_y))
				step_size = max(adx, ady)
			_anchor.step_size = step_size
			if(step_size > jump_threshold)
				_last_x = x
				_last_y = y
			else
				_last_x = X
				_last_y = Y
			_anchor.SetCenter(_last_x, _last_y, entity.z)
