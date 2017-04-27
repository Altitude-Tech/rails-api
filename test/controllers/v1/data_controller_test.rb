require 'test_helper'

module V1
  class DataControllerTest < ActionController::TestCase
    ##
    #
    ##
    CREATE_DATA = {
      humidity: 30,
      pressure: 1000,
      temperature: 20,
      log_time: Time.now.utc.to_i,
      data: [{
        sensor_type: RawDatum::SENSOR_MQ2_HASH,
        sensor_error: 0.0,
        sensor_data: 3000,
        sensor_r0: 3000
      }]
    }.freeze

    ##
    # Test success of the `create` method.
    ##
    test 'create success' do
      data = create_data
      expected = {
        gases: {
          Alcohol: 5478.509,
          Methane: 5868.6898,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076
        }
      }

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
      data[:data][0].delete(:sensor_type)
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
      data[:data][0][:sensor_type] = 'invalid'
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
      data[:data][0].delete(:sensor_error)
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
      data[:data][0][:sensor_error] = 'invalid'
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
      data[:data][0][:sensor_error] = -1
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
      data[:data][0][:sensor_error] = 2
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
      data[:data][0][:sensor_error] = 0
      expected = {
        gases: {
          Alcohol: 5478.509,
          Methane: 5868.6898,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076
        }
      }

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
      data[:data][0][:sensor_error] = 1
      expected = {
        gases: {
          Alcohol: 5478.509,
          Methane: 5868.6898,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076
        }
      }

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
      data[:data][0].delete(:sensor_data)
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
      data[:data][0][:sensor_data] = 'invalid'
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
      data[:data][0][:sensor_data] = -1
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
      data[:data][0][:sensor_data] = 4096
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
      data[:data][0][:sensor_data] = 0
      expected = { gases: {} }

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
      data[:data][0][:sensor_data] = 4095
      expected = { gases: {} }

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
      data[:data][0][:sensor_data] = 0.1
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
      expected = {
        gases: {
          Alcohol: 5478.509,
          Methane: 5868.6898,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076
        }
      }

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
      expected = {
        gases: {
          Alcohol: 5478.509,
          Methane: 5868.6898,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076
        }
      }

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
      expected = {
        gases: {
          Hydrogen: 2573.2701,
          'Liquid Petroleum Gas': 1592.9848,
          Propane: 1743.3543
        }
      }

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
      expected = {
        gases: {
          Alcohol: 1546.8867,
          Methane: 1684.5838,
          Hydrogen: 515.9321,
          'Liquid Petroleum Gas': 318.4423,
          Propane: 343.4518
        }
      }

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
    # Test error handling for `create` with a duplicate entry.
    ##
    test 'create duplicate sensor' do
      data = create_data
      data[:data].push(data[:data][0])
      expected = {
        error: 113,
        message: 'Duplicate data submitted.',
        status: 400
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test `create` method with multiple sensor data entries for different gases.
    ##
    test 'create multiple different gases' do
      data = create_data
      data[:data].push({
        sensor_type: RawDatum::SENSOR_MQ135_HASH,
        sensor_error: 0.0,
        sensor_r0: 2786.3375,
        sensor_data: 2900
      })
      expected = {
        gases: {
          Alcohol: 5478.509,
          Methane: 5868.6898,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076,
          'Carbon Monoxide': 165.833,
          Ammonia: 39.9385,
          'Carbon Dioxide': 37.5145,
          Ethanol: 23.1593,
          Methyl: 13.5074,
          Acetone: 11.052
        }
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test `create` method with multiple sensor data entries for intersecting gases.
    ##
    test 'create multiple intersecting gases' do
      data = create_data
      data[:data].push({
        sensor_type: RawDatum::SENSOR_MQ7_HASH,
        sensor_error: 0.0,
        sensor_r0: 1258.8822,
        sensor_data: 1450
      })
      expected = {
        gases: {
          Alcohol: 3081.0906,
          Methane: 2990.4197,
          Hydrogen: 1345.0398,
          'Liquid Petroleum Gas': 831.6515,
          Propane: 904.8076
        }
      }

      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of the `show` method returning 0 results of data.
    ##
    test 'show success empty result' do
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

      login User.first!
      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test success of the `show` method returning multiple results of data.
    ##
    test 'show success with results' do
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
            sensor_name: RawDatum::SENSOR_MQ2_NAME,
            sensor_error: 0.0,
            sensor_data: 0,
            log_time: '2016-09-23T11:57:47.000Z',
            temperature: 20.0,
            humidity: 0.0,
            pressure: 1000.0
          }, {
            sensor_type: '4080cf866795cdaf370a641cbd8044453d79ae30',
            sensor_name: RawDatum::SENSOR_MQ2_NAME,
            sensor_error: 0.0,
            sensor_data: 0,
            log_time: '2016-09-23T11:57:48.000Z',
            temperature: 20.0,
            humidity: 0.0,
            pressure: 1000.0
          }
        ]
      }

      login User.first!
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
      data = {
        identity: Device.first!.identity
      }
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      login User.first!
      get :show, params: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `show` method when a device is not found.
    ##
    test 'show device not found' do
      data = {
        identity: 'invalid'
      }
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      login User.first!
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
  end
end
