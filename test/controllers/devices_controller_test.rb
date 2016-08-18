##
# Devices Api Controller tests
##

require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  ##
  # Test successful selection of all devices using fixtures
  ##
  test 'get all devices' do
    get(:index)

    expected = '{"devices":[{"device_id":"4567","device_type":"cdef"},' \
               '{"device_id":"1234","device_type":"abcd"}]}'

    assert_response(:success)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling of invalid argument for start parameter
  ##
  test 'invalid start' do
    get(:index, params: { start: 'invalid' })

    expected = '{"error":"Start must be an integer greater than 1."}'

    assert_response(:bad_request)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling of too low value of start parameter
  ##
  test 'too low start' do
    get(:index, params: { start: 0 })

    expected = '{"error":"Start must be an integer greater than 1."}'

    assert_response(:bad_request)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling of invalid argument for limit parameter
  ##
  test 'invalid limit' do
    get(:index, params: { limit: 'invalid' })

    expected = '{"error":"Limit must be an integer between 1 and 500."}'

    assert_response(:bad_request)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling of too low value of limit parameter
  ##
  test 'too low limit' do
    get(:index, params: { limit: 0 })

    expected = '{"error":"Limit must be an integer between 1 and 500."}'

    assert_response(:bad_request)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test error handling of too high value of limit parameter
  ##
  test 'too high limit' do
    get(:index, params: { limit: 501 })

    expected = '{"error":"Limit must be an integer between 1 and 500."}'

    assert_response(:bad_request)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test success of lower limit parameter
  ##
  test 'lower limit' do
    get(:index, params: { limit: 1 })

    expected = '{"devices":[{"device_id":"4567","device_type":"cdef"}]}'

    Rails.logger.debug(response.body)

    assert_response(:success)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Testt success of upper limit parameter
  ##
  test 'upper limit' do
    get(:index, params: { limit: 500 })

    expected = '{"devices":[{"device_id":"4567","device_type":"cdef"},' \
               '{"device_id":"1234","device_type":"abcd"}]}'

    assert_response(:success)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Testt retrieving out-of-bounds indicies
  ##
  test 'out-of-bounds' do
    get(:index, params: { start: 3 })

    expected = '{"devices":[]}'

    assert_response(:success)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end

  ##
  # Test successful selection by device id
  ##
  test 'get device' do
    get(:show, params: { id: 1234 })

    expected = '{"device_id":"1234","device_type":"abcd"}'

    assert_response(:success)
    assert_equal('application/json', response.content_type)
    assert_equal(expected, response.body)
  end
end
