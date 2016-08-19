# API Usage

All requests are authenticated by API keys, unless stated otherwise, which should be sent as part of the request.

For GET requests, send the API key as a parameter with the name `key`:
```
GET /path/to/api?key=<API_KEY>
```

For all others, include the key in the JSON request body with the name `key`:
```json
{
	"key": "<API_KEY>",
	// other parameters
	// ...
}
```

## To do
* Handle multiple devices to users/keys
* Access for map data?
* Find a way to generate this automatically.

## Data
* `POST /v1/data`

	Creates a new data entry.

	Request body:
	```json
	{
		"key": "<API_KEY>",
		"device": "<DEVICE_ID>",
		"log_time": "<LOG_TIME>",
		"temperature": "<TEMPERATURE>",
		"humidity": "<HUMIDITY>",
		"pressure": "<PRESSURE>",
		"data": [
			{
				"sensor_type": "<SENSOR_TYPE>",
				"sensor_error": "<SENSOR_ERROR>",
				"sensor_data": "<SENSOR_DATA>"
			},
			{
				"sensor_type": "<SENSOR_TYPE>",
				"sensor_error": "<SENSOR_ERROR>",
				"sensor_data": "<SENSOR_DATA>"
			},
			{
				"sensor_type": "<SENSOR_TYPE>",
				"sensor_error": "<SENSOR_ERROR>",
				"sensor_data": "<SENSOR_DATA>"
			},
		]
	}
	```

	Keys:
	* `did`: The device's id.
	* `log_time`: Unix time in seconds.
	* `temperature`: Temperature in °C.
	* `humidity`: The relative humidity.
	* `pressure`: The pressure in hPa.
	* `sensor_type`: The name of the sensor type as a SHA1 hash. Valid pre-hashed values are:
		* `mq2`
		* `mq7`
		* `mq135`
	* `sensor_error`: The standard error of the sensor.
	* `sensor_data`: The raw ADC value output by the sensor.

## Devices
* `POST /v1/devices`

	For registering a new device.

	Request body:
	```json
	{
		"device_id": "<DEVICE_ID>",
		"device_type": "<DEVICE_TYPE>"
	}
	```

	Keys:
	* `device_id`: The device's id.
	* `device_type`: The type of device as a SHA1 hash. Valid pre-hashed values are:
		* `test`

* `GET /v1/devices`

	Retrieves a list of devices. Limited to admins.

## Users
* `POST /v1/users`

	For registering a new user account. Returns an API key to be used in future requests.

	Request body:
	```json
	{
		"name": "<NAME>",
		"email": "<EMAIL>",
		"password": "<PASSWORD>"
	}
	```

	Keys:
	* `name`: The new user's name.
	* `email`: The new user's email address.
	* `password`: The new user's password.

	Returns:
	```json
	{
		"key": "<API_KEY>"
	}
	```

* `POST /v1/users/login`

	For logging in as a user. Returns the user's current API key.

	Request body:
	```json
	{
		"email": "<EMAIL>",
		"password": "<PASSWORD>"
	}
	```

	Keys:
	* `email`: The new user's email address.
	* `password`: The new user's password.

	Returns:
	```json
	{
		"key": "<API_KEY>"
	}
	```

* `POST /v1/users/new_key`

	For requesting a new api key. Invalidates the previously held key if applicable.

	Request body:
	```json
	{
		"email": "<EMAIL>",
		"password": "<PASSWORD>"
	}
	```

	Keys:
	* `email`: The new user's email address.
	* `password`: The new user's password.

	Returns:
	```json
	{
		"key": "<API_KEY>"
	}
	```
