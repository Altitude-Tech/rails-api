# API Usage

## To do
* Handle multiple devices to users/keys
* Access for map data?

## Data
* `POST /v1/data`
	Create a new data entry.
	Authenticated API key.

	```json
	{
		"key": "<API_KEY>",
		"did": "<DEVICE_ID>",
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

	* `log_time`: Unix time in seconds.
	* `temperature`: Temperature in °C.
	* `humidity`: Relative humidity.
	* `pressure`: Pressure in hPa.
	* `sensor_type`: Sensor type as a SHA1 hash.
	* `sensor_error`: Standard error of the sensor.

* `GET  /v1/data/:device`
	Get a list of data for a specific device.
	Authenticated by API key.

	Parameters:
	* `key` (required): A valid API key.

	Example:
	````
	/v1/data/<DEVICE_ID>?key=<API_KEY>
	```

## Devices
* `POST /v1/devices`
	Create a new device entry.
	Authenticated by API key.

* `GET  /v1/devices`
	Get a list of devices.
	Restricted to admins.
	Authenticated by API key.

* `GET  /v1/devices/:id`
	Get a specific device for it's id.
	Authenticated by API key.

## Users
* `POST /v1/users`
	Create a new user entry.
	Generates a new API key for the user.

* `GET /v1/users`
	Get a list of users.
	Restricted to admins,
	Authenticated by API key.

* `GET /v1/users/:id`
	Get a specific user from it's id.
	Restricted to admins.

* `GET /v1/users/:key`
	Get a specific user based on it's API key.

* `PATCH /v1/users/:key`
* `PUT /v1/users/:key`
	Update a specific user's credentials.
	Authenticated by API key.

## Keys
* `POST /v1/keys/:user_id`
	Generates a new API key for a user.
	Restricted? Needs some kind of auth.

* `DELETE /v1/keys/:user_id`
	Invalidates a user's API key.
	Restricted to admins.
	Authenticated by API key.
