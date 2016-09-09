##
# DataController tests
##

require 'test_helper'

module V1
  class DataControllerTest < ActionController::TestCase
    # base data hash to be manipulated as required
    BASE_DATA = {
      device_id: 4567,
      log_time: Time.now.to_i,
      temperature: 293.15,
      pressure: 101_325.0,
      humidity: 63.12,
      data: [{
        sensor_type: Datum::SENSOR_MQ2,
        sensor_error: 0.1,
        sensor_data: 47
      }]
    }.freeze

    ##
    # Test error handling for invalid json
    ##
    test 'create invalid request body' do
      expected = {
        error: 1,
        message: 'There was a problem in the JSON you submitted: 784: unexpected token at ' \
          '\'invalid\'',
        status: 400
      }

      post(:create, body: 'invalid')

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing device id key
    ##
    test 'create missing device id' do
      data = BASE_DATA.deep_dup
      data.delete(:device_id)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'device_id'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid device id
    ##
    test 'create invalid device_id' do
      data = BASE_DATA.deep_dup
      data[:device_id] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'device_id'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing log_time
    ##
    test 'create missing log time' do
      data = BASE_DATA.deep_dup
      data.delete(:log_time)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'log_time'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid log_time
    ##
    test 'create invalid log_time' do
      data = BASE_DATA.deep_dup
      data[:log_time] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'log_time'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for log_time in milliseconds
    ##
    test 'create millisecond log time' do
      data = BASE_DATA.deep_dup
      data[:log_time] *= 1000
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'log_time'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing temperature key
    ##
    test 'create missing temperature' do
      data = BASE_DATA.deep_dup
      data.delete(:temperature)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'temperature'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid temperature
    ##
    test 'create invalid temperature' do
      data = BASE_DATA.deep_dup
      data[:temperature] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'temperature'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing humidity
    ##
    test 'create missing humidity' do
      data = BASE_DATA.deep_dup
      data.delete(:humidity)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'humidity'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid humidity
    ##
    test 'create invalid humidity' do
      data = BASE_DATA.deep_dup
      data[:humidity] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'humidity'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing pressure
    ##
    test 'create missing pressure' do
      data = BASE_DATA.deep_dup
      data.delete(:pressure)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'pressure'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid pressure
    ##
    test 'create invalid pressure' do
      data = BASE_DATA.deep_dup
      data[:pressure] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'pressure'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing data
    ##
    test 'create missing data' do
      data = BASE_DATA.deep_dup
      data.delete(:data)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'data'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid data
    ##
    test 'create invalid data' do
      data = BASE_DATA.deep_dup
      data[:data] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'data'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing sensor_type
    ##
    test 'create missing sensor type' do
      data = BASE_DATA.deep_dup
      data[:data][0].delete(:sensor_type)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_type'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid sensor_type
    ##
    test 'create invalid sensor_type' do
      data = BASE_DATA.deep_dup
      data[:data][0][:sensor_type] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_type'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing sensor_error
    ##
    test 'create missing sensor error' do
      data = BASE_DATA.deep_dup
      data[:data][0].delete(:sensor_error)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_error'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid sensor_error
    ##
    test 'create invalid sensor_error' do
      data = BASE_DATA.deep_dup
      data[:data][0][:sensor_error] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_error'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing sensor_data
    ##
    test 'create missing sensor data' do
      data = BASE_DATA.deep_dup
      data[:data][0].delete(:sensor_data)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_data'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid sensor_data
    ##
    test 'create invalid sensor_data' do
      data = BASE_DATA.deep_dup
      data[:data][0][:sensor_data] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_data'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test successful creation
    ##
    test 'create success' do
      data = BASE_DATA.deep_dup
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test multiple create with error
    ##
    test 'create multiple with error' do
      expected1 = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'sensor_data'),
        status: 400
      }
      expected2 = {
        data: []
      }

      # create a new device first
      device_id = 6789
      Device.create!(device_id: device_id, device_type: Device::TYPE_TEST)

      data = BASE_DATA.deep_dup
      data[:device_id] = device_id
      child_data = data[:data][0]

      data[:data].append(child_data.clone)
      data[:data][1][:sensor_data] = 'invalid'

      post(:create, body: data.to_json)

      # make sure the first request failed
      assert_equal(expected1.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)

      # double check nothing was inserted
      get(:show, params: { device_id: device_id })

      assert_equal(expected2.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test multiple successful create
    ##
    test 'create multiple success' do
      data = BASE_DATA.deep_dup
      child_data = data[:data][0]
      data[:data].append(child_data.clone)
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      Rails.logger.debug(data)

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test show method success
    ##
    test 'show success' do
      expected = {
        data: [
          {
            device_id: 1,
            sensor_name: Datum::SENSOR_MQ2_RAW,
            sensor_type: Datum::SENSOR_MQ2,
            sensor_data: 1.5,
            sensor_error: '9.99',
            temperature: 293.15,
            pressure: 101_325.0,
            humidity: 60.0,
            log_time: '2016-07-13 16:31:36 UTC'
          }
        ]
      }

      get(:show, params: { device_id: 1234 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test show error handling for invalid device id
    ##
    test 'show not found' do
      args = { model: 'device', key: 'device_id', value: 'invalid' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      get(:show, params: { device_id: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end
  end
end
