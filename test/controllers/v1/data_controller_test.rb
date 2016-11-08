require 'test_helper'

module V1
  class DataControllerTest < ActionController::TestCase
    ##
    #
    ##
    CREATE_DATA = {
      sensor_type: Datum::SENSOR_MQ2_HASH,
      sensor_error: 0.0,
      sensor_data: 1000,
      humidity: 0,
      pressure: 1000,
      temperature: 20.0,
      log_time: Time.now.utc.to_i
    }.freeze

    ##
    # Test success of the `create` method.
    ##
    test 'create success' do
      data = create_data
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `create` with a missing `identity` parameter.
    ##
    test 'create missing identity' do
      data = create_data
      data.delete(:identity)
      expected = {
        error: 104,
        message: '"identity" not found.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `identity` parameter.
    ##
    test 'create invalid identity' do
      data = create_data
      data[:identity] = 'invalid'
      expected = {
        error: 104,
        message: '"identity" not found.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a missing `token` parameter.
    ##
    test 'create missing token' do
      data = create_data
      data.delete(:token)
      expected = {
        error: 108,
        message: 'Not authorised.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `token` parameter.
    ##
    test 'create invalid token' do
      data = create_data
      data[:token] = 'invalid'
      expected = {
        error: 108,
        message: 'Not authorised.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a missing `sensor_type` parameter.
    ##
    test 'create missing sensor_type' do
      data = create_data
      data.delete(:sensor_type)
      expected = {
        error: 103,
        message: '"sensor_type" is invalid or missing.',
        user_message: 'Sensor type is invalid or missing.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `sensor_type` parameter.
    ##
    test 'create invalid sensor_type' do
      data = create_data
      data[:sensor_type] = 'invalid'
      expected = {
        error: 103,
        message: '"sensor_type" is invalid or missing.',
        user_message: 'Sensor type is invalid or missing.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a missing `sensor_error` parameter.
    ##
    test 'create missing sensor_error' do
      data = create_data
      data.delete(:sensor_error)
      expected = {
        error: 103,
        message: '"sensor_error" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        user_message: 'Sensor error must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `sensor_error` parameter.
    ##
    test 'create invalid sensor_error' do
      data = create_data
      data[:sensor_error] = 'invalid'
      expected = {
        error: 103,
        message: '"sensor_error" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        user_message: 'Sensor error must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too low `sensor_error` parameter.
    ##
    test 'create too low sensor_error' do
      data = create_data
      data[:sensor_error] = -1
      expected = {
        error: 103,
        message: '"sensor_error" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        user_message: 'Sensor error must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too high `sensor_error` parameter.
    ##
    test 'create too high sensor_error' do
      data = create_data
      data[:sensor_error] = 2
      expected = {
        error: 103,
        message: '"sensor_error" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        user_message: 'Sensor error must be a number greater than or equal to 0 and ' \
                 'less than or equal to 1.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of `create` method with a `sensor_error` parameter at the lower limit.
    ##
    test 'create lower limit sensor_error' do
      data = create_data
      data[:sensor_error] = 0
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of `create` method with a `sensor_error` parameter at the upper limit.
    ##
    test 'create upper limit sensor_error' do
      data = create_data
      data[:sensor_error] = 1
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `create` with a missing `sensor_data` parameter.
    ##
    test 'create missing sensor_data' do
      data = create_data
      data.delete(:sensor_data)
      expected = {
        error: 103,
        message: '"sensor_data" must be an integer greater than or equal to 0 and ' \
                 'less than 4096.',
        user_message: 'Sensor data must be an integer greater than or equal to 0 and ' \
                      'less than 4096.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `sensor_data` parameter.
    ##
    test 'create invalid sensor_data' do
      data = create_data
      data[:sensor_data] = 'invalid'
      expected = {
        error: 103,
        message: '"sensor_data" must be an integer greater than or equal to 0 and ' \
                 'less than 4096.',
        user_message: 'Sensor data must be an integer greater than or equal to 0 and ' \
                      'less than 4096.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too low `sensor_data` parameter.
    ##
    test 'create too low sensor_data' do
      data = create_data
      data[:sensor_data] = -1
      expected = {
        error: 103,
        message: '"sensor_data" must be an integer greater than or equal to 0 and ' \
                 'less than 4096.',
        user_message: 'Sensor data must be an integer greater than or equal to 0 and ' \
                      'less than 4096.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too high `sensor_data` parameter.
    ##
    test 'create too high sensor_data' do
      data = create_data
      data[:sensor_data] = 4096
      expected = {
        error: 103,
        message: '"sensor_data" must be an integer greater than or equal to 0 and ' \
                 'less than 4096.',
        user_message: 'Sensor data must be an integer greater than or equal to 0 and ' \
                      'less than 4096.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of `create` method with a `sensor_data` parameter at the lower limit.
    ##
    test 'create lower limit sensor_data' do
      data = create_data
      data[:sensor_data] = 0
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of `create` method with a `sensor_data` parameter at the upper limit.
    ##
    test 'create upper limit sensor_data' do
      data = create_data
      data[:sensor_data] = 4095
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `create` with a non-integer `sensor_data` parameter.
    ##
    test 'create non-integer sensor_data' do
      data = create_data
      data[:sensor_data] = 0.1
      expected = {
        error: 103,
        message: '"sensor_data" must be an integer greater than or equal to 0 and ' \
                 'less than 4096.',
        user_message: 'Sensor data must be an integer greater than or equal to 0 and ' \
                      'less than 4096.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a missing `log_time` parameter.
    ##
    test 'create missing log_time' do
      data = create_data
      data.delete(:log_time)
      expected = {
        error: 103,
        message: '"log_time" is an invalid value.',
        user_message: 'Log time is an invalid value.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `log_time` parameter.
    ##
    test 'create invalid log_time' do
      data = create_data
      data[:log_time] = 'invalid'
      expected = {
        error: 103,
        message: '"log_time" is an invalid value.',
        user_message: 'Log time is an invalid value.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too low `log_time` parameter.
    ##
    test 'create too low log_time' do
      data = create_data
      data[:log_time] = (Time.now.utc - 31.days).to_i
      expected = {
        error: 103,
        message: '"log_time" is below the minimum allowed value.',
        user_message: 'Log time is below the minimum allowed value.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too high `log_time` parameter.
    ##
    test 'create too high log_time' do
      data = create_data
      data[:log_time] = (Time.now.utc + 1.day).to_i
      expected = {
        error: 103,
        message: '"log_time" is above the maximum allowed value.',
        user_message: 'Log time is above the maximum allowed value.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of `create` method with a `log_time` parameter at the lower limit.
    ##
    test 'create lower limit log_time' do
      data = create_data
      data[:log_time] = (Time.now.utc - 30.days).to_i
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of `create` method with a `log_time` parameter at the upper limit.
    ##
    test 'create upper limit log_time' do
      data = create_data
      data[:log_time] = Time.now.utc.to_i
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `create` with a missing `temperature` parameter.
    ##
    test 'create missing temperature' do
      data = create_data
      data.delete(:temperature)
      expected = {
        error: 103,
        message: '"temperature" must be a number.',
        user_message: 'Temperature must be a number.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `temperature` parameter.
    ##
    test 'create invalid temperature' do
      data = create_data
      data[:temperature] = 'invalid'
      expected = {
        error: 103,
        message: '"temperature" must be a number.',
        user_message: 'Temperature must be a number.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a missing `humidity` parameter.
    ##
    test 'create missing humidity' do
      data = create_data
      data.delete(:humidity)
      expected = {
        error: 103,
        message: '"humidity" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 100.',
        user_message: 'Humidity must be a number greater than or equal to 0 and ' \
                      'less than or equal to 100.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `humidity` parameter.
    ##
    test 'create invalid humidity' do
      data = create_data
      data[:humidity] = 'invalid'
      expected = {
        error: 103,
        message: '"humidity" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 100.',
        user_message: 'Humidity must be a number greater than or equal to 0 and ' \
                      'less than or equal to 100.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too low `humidity` parameter.
    ##
    test 'create too low humidity' do
      data = create_data
      data[:humidity] = -1
      expected = {
        error: 103,
        message: '"humidity" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 100.',
        user_message: 'Humidity must be a number greater than or equal to 0 and ' \
                      'less than or equal to 100.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with a too high `humidity` parameter.
    ##
    test 'create too high humidity' do
      data = create_data
      data[:humidity] = 101
      expected = {
        error: 103,
        message: '"humidity" must be a number greater than or equal to 0 and ' \
                 'less than or equal to 100.',
        user_message: 'Humidity must be a number greater than or equal to 0 and ' \
                      'less than or equal to 100.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of `create` method with a `humidity` parameter at the lower limit.
    ##
    test 'create lower limit humidity' do
      data = create_data
      data[:humidity] = 0
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of `create` method with a `humidity` parameter at the upper limit.
    ##
    test 'create upper limit humidity' do
      data = create_data
      data[:humidity] = 100
      expected = { result: 'success' }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `create` with a missing `pressure` parameter.
    ##
    test 'create missing pressure' do
      data = create_data
      data.delete(:pressure)
      expected = {
        error: 103,
        message: '"pressure" must be a number.',
        user_message: 'Pressure must be a number.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `create` with an invalid `pressure` parameter.
    ##
    test 'create invalid pressure' do
      data = create_data
      data[:pressure] = 'invalid'
      expected = {
        error: 103,
        message: '"pressure" must be a number.',
        user_message: 'Pressure must be a number.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of the `show` method returning 0 results of data.
    ##
    test 'show success empty result' do
      login
      create_data
      data = {
        identity: Device.first!.identity
      }
      expected = {
        device: {
          identity: '77834ac5938cbd0c119b22d8bf171824',
          type: 'b28b7af69320201d1cf206ebf28373980add1451',
          name: 'main'
        },
        data: []
      }

      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of the `show` method returning multiple results of data.
    ##
    test 'show success with results' do
      login
      group = Group.first!
      device = Device.find 2
      device.register! group
      data = {
        identity: device.identity
      }
      expected = {
        device: {
          identity: '6b58d18a8df4600ec5c08a71da081b93',
          type: 'b28b7af69320201d1cf206ebf28373980add1451',
          name: 'main'
        },
        data: [
          {
            sensor_type: '4080cf866795cdaf370a641cbd8044453d79ae30',
            sensor_error: 0.0,
            sensor_data: 0,
            log_time: '2016-09-23T11:57:47.000Z',
            temperature: 20.0,
            humidity: 0.0,
            pressure: 1000.0
          }, {
            sensor_type: '4080cf866795cdaf370a641cbd8044453d79ae30',
            sensor_error: 0.0,
            sensor_data: 0,
            log_time: '2016-09-23T11:57:47.000Z',
            temperature: 20.0,
            humidity: 0.0,
            pressure: 1000.0
          }
        ]
      }

      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `show` method when a user is not logged in.
    ##
    test 'show not logged in' do
      data = {
        identity: Device.first!.identity
      }
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `show` method when a user is not authorised to view the data.
    ##
    test 'show not authorised' do
      login
      data = {
        identity: Device.first!.identity
      }
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `show` method when a device is not found.
    ##
    test 'show device not found' do
      login
      data = {
        identity: 'invalid'
      }
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    private

    ##
    # Helper method to register a device and return data ready to send for said device.
    ##
    def create_data
      data = CREATE_DATA.deep_dup
      device = Device.first!
      group = Group.first!

      token = device.register! group

      data[:identity] = device.identity
      data[:token] = token.token

      return data
    end

    ##
    # Set a session cookie to fake being logged in.
    ##
    def login
      user = User.first!
      token = user.authenticate! 'password'

      cookies.signed[:session] = token.token
    end
  end
end
