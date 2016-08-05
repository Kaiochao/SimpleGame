Camera
	parent_type = /Component

	var tmp/client/_client

	var x
	var y

	proc/SetPosition(X, Y)
		x = X
		y = Y

	proc/Start()
		_client = entity.GetWrappedValue(/Wrapper/Client)
		_client.eye = entity
		_client.perspective = EYE_PERSPECTIVE

	proc/Destroy()
		_client = null
		_client.eye = _client.mob
		_client.perspective = initial(_client.perspective)

	proc/Update()
		var client_pixel_x = x - entity.GetCenterX()
		var client_pixel_y = y - entity.GetCenterY()

		if(_client.pixel_x != client_pixel_x || _client.pixel_y != client_pixel_y)
			animate(_client,
				pixel_x = client_pixel_x,
				pixel_y = client_pixel_y,
				time = 1)
