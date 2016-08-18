##
#
##

require 'test_helper'

##
# ApiController tests
##
class ApiControllerTest < ActionController::TestCase
  # base data hash to be manipulated as required
  BASE_DATA = {
    DID: '5678',
    DYPE: '1234',
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
  # Test acceptance of GET request
  ##
  test 'recognise GET' do
    assert_recognizes(
      { controller: 'api', action: 'index' },
      { path: 'api', method: :get }
    )
  end

  ##
  # Test acceptance of POST request
  ##
  test 'recognise POST' do
    assert_recognizes(
      { controller: 'api', action: 'create' },
      { path: 'api', method: :post }
    )
  end

  ##
  # Test error handling for no request body
  ##
  test 'no request body' do
    post :create

    expected = '{"error":"Missing request body."}'

    assert_response :bad_request
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for invalid json in the request body
  ##
  test 'invalid request body' do
    post :create, body: 'invalid'

    expected = '{"error":"There was a problem in the JSON you submitted: ' \
               '784: unexpected token at \'invalid\'"}'

    assert_response :bad_request
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing device id key in JSON request body
  ##
  test 'missing device id' do
    data = BASE_DATA.deep_dup.except(:DID)

    expected = '{"error":"Missing key in request body: \"did\"."}'

    post :create, body: data.to_json

    assert_response :bad_request
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing device type key in JSON request body
  ##
  test 'missing device type' do
    data = BASE_DATA.deep_dup.except(:DYPE)

    expected = '{"error":"Missing key in request body: \"dype\"."}'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing log time key in JSON request body
  ##
  test 'missing log time' do
    data = BASE_DATA.deep_dup.except(:LOG_TIME)

    expected = '{"error":"Missing key in request body: \"log_time\"."}'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing data key in JSON request body
  ##
  test 'missing data' do
    data = BASE_DATA.deep_dup.except(:DATA)

    expected = '{"error":"Missing key in request body: \"data\"."}'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing sensor type key in JSON request body
  ##
  test 'missing sensor type' do
    data = BASE_DATA.deep_dup
    data[:DATA][0].delete(:SENSOR_TYPE)

    expected = '{"error":"Missing key in request body: \"sensor_type\"."}'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing sensor error key in JSON request body
  ##
  test 'missing sensor error' do
    data = BASE_DATA.deep_dup
    data[:DATA][0].delete(:SENSOR_ERROR)

    post :create, body: data.to_json

    expected = '{"error":"Missing key in request body: \"sensor_error\"."}'

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing sensor data key in JSON request body
  ##
  test 'missing sensor data' do
    data = BASE_DATA.deep_dup
    data[:DATA][0].delete(:SENSOR_DATA)

    expected = '{"error":"Missing key in request body: \"sensor_data\"."}'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test successful creation
  ##
  test 'successful create' do
    data = BASE_DATA.deep_dup
    Rails.logger.debug(data.to_json)

    expected = 'Data inserted successfully.'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end
end
