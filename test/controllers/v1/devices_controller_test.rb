##
# DevicesController tests
##

require 'test_helper'

module V1
  class DevicesControllerTest < ActionController::TestCase
    ##
    # Test successful selection of all devices using fixtures
    ##
    test 'get all devices' do
      expected = '{"devices":[{"device_id":"1234","device_type":"abcd"},' \
                 '{"device_id":"4567","device_type":"cdef"}]}'

      get(:index)

      assert_response(:success)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling of invalid argument for start parameter
    ##
    test 'invalid start' do
      expected = '{"error":"Start must be an integer greater than 1."}'

      get(:index, params: { start: 'invalid' })

      assert_response(:bad_request)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling of too low value of start parameter
    ##
    test 'too low start' do
      expected = '{"error":"Start must be an integer greater than 1."}'

      get(:index, params: { start: 0 })

      assert_response(:bad_request)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling of invalid argument for limit parameter
    ##
    test 'invalid limit' do
      expected = '{"error":"Limit must be an integer between 1 and 500."}'

      get(:index, params: { limit: 'invalid' })

      assert_response(:bad_request)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling of too low value of limit parameter
    ##
    test 'too low limit' do
      expected = '{"error":"Limit must be an integer between 1 and 500."}'

      get(:index, params: { limit: 0 })

      assert_response(:bad_request)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test error handling of too high value of limit parameter
    ##
    test 'too high limit' do
      expected = '{"error":"Limit must be an integer between 1 and 500."}'

      get(:index, params: { limit: 501 })

      assert_response(:bad_request)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test success of lower limit parameter
    ##
    test 'lower limit' do
      expected = '{"devices":[{"device_id":"1234","device_type":"abcd"}]}'

      get(:index, params: { limit: 1 })

      assert_response(:success)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test success of upper limit parameter
    ##
    test 'upper limit' do
      get(:index, params: { limit: 500 })

      expected = '{"devices":[{"device_id":"1234","device_type":"abcd"},' \
                 '{"device_id":"4567","device_type":"cdef"}]}'

      assert_response(:success)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test retrieving out-of-bounds indicies
    ##
    test 'out-of-bounds' do
      get(:index, params: { start: 3 })

      expected = '{"error":"No more devices were found."}'

      assert_response(:bad_request)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end

    ##
    # Test successful selection by device id
    ##
    test 'get device' do
      expected = '{"device_id":"1234","device_type":"abcd"}'

      get(:show, params: { id: 1234 })

      assert_response(:success)
      assert_equal('application/json', response.content_type)
      assert_equal(expected, response.body)
    end
  end
end
