##
# DataController tests
##

require 'test_helper'

module V1
  class DataControllerTest < ActionController::TestCase
    # base data hash to be manipulated as required
    BASE_DATA = {
      DID: 4567,
      LOG_TIME: Time.now.to_i,
      TEMPERATURE: 25.37,
      PRESSURE: 1009.30,
      HUMIDITY: 63.12,
      DATA: [{
        SENSOR_TYPE: SENSOR_MQ2_HASH,
        SENSOR_ERROR: 0.1,
        SENSOR_DATA: 47
      }]
    }.freeze

    ##
    # Test error handling for no request body
    ##
    test 'create no request body' do
      post :create
      expected = {
        error: I18n.t('controller.v1.error.missing_request_body')
      }

      assert_response :bad_request
      assert_equal(expected.to_json, response.body)
    end

    ##
    # Test error handling for invalid json in the request body
    ##
    test 'create invalid request body' do
      post :create, body: 'invalid'
      expected = '{"error":"There was a problem in the JSON you submitted: ' \
                 '784: unexpected token at \'invalid\'"}'

      assert_response :bad_request
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for missing device id key in JSON request body
    ##
    test 'create missing device id' do
      data = BASE_DATA.deep_dup.except(:DID)
      expected = '{"error":"Missing key in request body: \"did\"."}'

      post :create, body: data.to_json

      assert_response :bad_request
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for missing log time key in JSON request body
    ##
    test 'create missing log time' do
      data = BASE_DATA.deep_dup.except(:LOG_TIME)
      expected = '{"error":"Missing key in request body: \"log_time\"."}'

      post :create, body: data.to_json

      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for log_time in milliseconds
    ##
    test 'create millisecond log time' do
      data = BASE_DATA.deep_dup
      data[:LOG_TIME] *= 1000
      expected = '{"error":"\"log_time\" must be unix time in seconds."}'

      post :create, body: data.to_json

      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for missing data key in JSON request body
    ##
    test 'create missing data' do
      data = BASE_DATA.deep_dup.except(:DATA)
      expected = '{"error":"Missing key in request body: \"data\"."}'

      post :create, body: data.to_json

      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for missing sensor type key in JSON request body
    ##
    test 'create missing sensor type' do
      data = BASE_DATA.deep_dup
      data[:DATA][0].delete(:SENSOR_TYPE)
      expected = '{"error":"Missing key in request body: \"sensor_type\"."}'

      post :create, body: data.to_json

      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for missing sensor error key in JSON request body
    ##
    test 'create missing sensor error' do
      data = BASE_DATA.deep_dup
      data[:DATA][0].delete(:SENSOR_ERROR)
      expected = '{"error":"Missing key in request body: \"sensor_error\"."}'

      post :create, body: data.to_json

      assert_equal(expected, response.body)
    end

    ##
    # Test error handling for missing sensor data key in JSON request body
    ##
    test 'create missing sensor data' do
      data = BASE_DATA.deep_dup
      data[:DATA][0].delete(:SENSOR_DATA)
      expected = '{"error":"Missing key in request body: \"sensor_data\"."}'

      post(:create, body: data.to_json)

      assert_equal(expected, response.body)
    end

    ##
    # Test successful creation
    ##
    test 'create success' do
      data = BASE_DATA.deep_dup
      expected = '{"success":"Data successfully inserted."}'

      post :create, body: data.to_json

      assert_equal(expected, response.body)
    end

    ##
    #
    ##
    test 'show success' do
      expected = {}

      get(:show, params: { device_id: 1234 })

      assert_equal(expected.to_json, response.body)
    end

    ##
    #
    ##
    test 'show not found' do
      expected = {}

      get(:show, params: { device_id: 'invalid' })

      assert_equal(expected.to_json, response.body)
    end
  end
end
