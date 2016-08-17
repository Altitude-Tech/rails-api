##
# Api Controller tests
##

require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  # base data hash to be manipulated as required
  BASE_DATA = {
    DID: '5678',
    DYPE: '1234',
    LOG_TIME: Time.now.to_i,
    TEMPERATURE: 25.37,
    PRESSURE: 1009.30164141,
    HUMIDITY: 63.1271798896,
    DATA: {
      SENSOR_TYPE: SENSOR_MQ2_HASH,
      SENSOR_ERROR: 0.1,
      SENSOR_DATA: 47,
    }
  }

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

    expected = 'Missing request body.'

    assert_response :bad_request
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing device id key in JSON request body
  ##
  test 'missing device id' do
    data = BASE_DATA.deep_dup.except(:DID)

    expected = 'Key not found: DID (Device id).'

    post :create, body: data.to_json

    assert_response :bad_request
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing device type key in JSON request body
  ##
  test 'missing device type' do
    data = BASE_DATA.deep_dup.except(:DYPE)

    expected = 'Key not found: DYPE (Device type).'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing log time key in JSON request body
  ##
  test 'missing log time' do
    data = BASE_DATA.deep_dup.except(:LOG_TIME)

    expected = 'Validation failed: Log_time (LOG_TIME) can\'t be blank'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing data key in JSON request body
  ##
  test 'missing data' do
    data = BASE_DATA.deep_dup.except(:DATA)

    expected = 'Key not found: DATA (Data).'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing sensor type key in JSON request body
  ##
  test 'missing sensor type' do
    data = BASE_DATA.deep_dup
    data[:DATA].delete(:SENSOR_TYPE)

    expected = 'Validation failed: Sensor type (SENSOR_TYPE) is an ' \
               'unrecognised value.'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing sensor error key in JSON request body
  ##
  test 'missing sensor error' do
    data = BASE_DATA.deep_dup
    data[:DATA].delete(:SENSOR_ERROR)

    post :create, body: data.to_json

    expected = 'Validation failed: Sensor error (SENSOR_ERROR) must be a ' \
               'number between 0 and 1.'

    assert_equal(expected, response.body)
  end

  ##
  # Test error handling for missing sensor data key in JSON request body
  ##
  test 'missing sensor data' do
    data = BASE_DATA.deep_dup
    data[:DATA].delete(:SENSOR_DATA)

    expected = 'Validation failed: Sensor data (SENSOR_DATA) must be a ' \
               'number greater than or equal to 0.'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end

  ##
  # Test successful creation
  ##
  test 'successful create' do
    data = BASE_DATA.deep_dup

    expected = 'Data inserted successfully.'

    post :create, body: data.to_json

    assert_equal(expected, response.body)
  end
end
