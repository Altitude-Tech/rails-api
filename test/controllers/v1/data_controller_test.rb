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
    # Test error handling for no request body
    ##
    test 'create no request body' do
      expected = {
        error: I18n.t('controller.v1.error.missing_request_body')
      }

      post(:create)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for invalid json in the request body
    ##
    test 'create invalid request body' do
      expected = '{"error":"There was a problem in the JSON you submitted: ' \
                 '784: unexpected token at \'invalid\'"}'

      post(:create, body: 'invalid')

      assert_equal(expected, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing device id key in JSON request body
    ##
    test 'create missing device id' do
      data = BASE_DATA.deep_dup
      data.delete(:device_id)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'device_id')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing log time key in JSON request body
    ##
    test 'create missing log time' do
      data = BASE_DATA.deep_dup
      data.delete(:log_time)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'log_time')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'log_time')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing data key in request body
    ##
    test 'create missing data' do
      data = BASE_DATA.deep_dup
      data.delete(:data)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'data')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing sensor type key in request body
    ##
    test 'create missing sensor type' do
      data = BASE_DATA.deep_dup
      data[:data][0].delete(:sensor_type)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'sensor_type')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing sensor error key in request body
    ##
    test 'create missing sensor error' do
      data = BASE_DATA.deep_dup
      data[:data][0].delete(:sensor_error)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'sensor_error')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for missing sensor data key in request body
    ##
    test 'create missing sensor data' do
      data = BASE_DATA.deep_dup
      data[:data][0].delete(:sensor_data)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'sensor_data')
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
      assert_response(:success)
    end

    ##
    #
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
      assert_response(:success)
    end

    ##
    #
    ##
    test 'show not found' do
      args = { model: 'device', key: 'device_id', value: 'invalid' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      get(:show, params: { device_id: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end
  end
end
