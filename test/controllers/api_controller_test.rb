require 'test_helper'

class ApiControllerTest < ActionController::TestCase
	test 'recognise GET' do
		assert_recognizes(
			{controller: 'api', action: 'index'},
			{path: 'api', method: :get}
		)
	end

	test 'recognise POST' do
		assert_recognizes(
			{controller: 'api', action: 'create'},
			{path: 'api', method: :post}
		)
	end

	test 'no request body' do
		post :create

		assert_response :bad_request
		assert_equal 'Missing request body.', response.body
	end

	test 'missing device id' do
		data = {
			:DYPE => '1234',
			:LOG_TIME => Time.now.to_i,
			:DATA => {
				:SENSOR_TYPE => 'af123',
				:SENSOR_ERROR => 0.0,
				:SENSOR_DATA => 10
			}
		}

		post :create, body: data.to_json

		assert_response :bad_request
		assert_equal 'Key not found: DID (Device id).', response.body
	end

	test 'missing device type' do
		data = {
			:DID => '12a4',
			:LOG_TIME => Time.now.to_i,
			:DATA => {
				:SENSOR_TYPE => 'af123',
				:SENSOR_ERROR => 0.0,
				:SENSOR_DATA => 10
			}
		}

		post :create, body: data.to_json

		assert_equal 'Key not found: DYPE (Device type).', response.body
	end

	test 'missing log time' do
		data = {
			:DID => '12a4',
			:DYPE => '1234',
			:DATA => {
				:SENSOR_TYPE => 'af123',
				:SENSOR_ERROR => 0.0,
				:SENSOR_DATA => 10
			}
		}

		post :create, body: data.to_json

		assert_equal 'Validation failed: Log_time (LOG_TIME) can\'t be blank', response.body
	end

	test 'missing data' do
		data = {
			:DID => '12a4',
			:DYPE => '1234',
			:LOG_TIME => Time.now.to_i
		}

		post :create, body: data.to_json

		assert_equal 'Key not found: DATA (Data).', response.body
	end

	test 'missing sensor type' do
		data = {
			:DID => '12a4',
			:DYPE => '1234',
			:LOG_TIME => Time.now.to_i,
			:DATA => {
				:SENSOR_ERROR => 0.0,
				:SENSOR_DATA => 10
			}
		}

		post :create, body: data.to_json

		assert_equal 'Validation failed: Sensor type (SENSOR_TYPE) must be a hexadecimal number.', response.body
	end

	test 'missing sensor error' do
		data = {
			:DID => '12a4',
			:DYPE => '1234',
			:LOG_TIME => Time.now.to_i,
			:DATA => {
				:SENSOR_TYPE => 'af123',
				:SENSOR_DATA => 10
			}
		}

		post :create, body: data.to_json

		assert_equal 'Validation failed: Sensor error (SENSOR_ERROR) must be a number between 0 and 1.', response.body
	end

	test 'missing sensor data' do
		data = {
			:DID => '12a4',
			:DYPE => '1234',
			:LOG_TIME => Time.now.to_i,
			:DATA => {
				:SENSOR_TYPE => 'af123',
				:SENSOR_ERROR => 0.0
			}
		}

		post :create, body: data.to_json

		assert_equal 'Validation failed: Sensor data (SENSOR_DATA) must be a number greater than or equal to 0.', response.body
	end

	test 'successful create' do
		data = {
			:DID => '12a4',
			:DYPE => '1234',
			:LOG_TIME => Time.now.to_i,
			:DATA => {
				:SENSOR_TYPE => 'af123',
				:SENSOR_ERROR => 0.0,
				:SENSOR_DATA => 10
			}
		}

		post :create, body: data.to_json

		assert_equal 'Data inserted successfully.', response.body
	end
end