require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
	test 'get all devices' do
		get :index

		expected_resp = '{"devices":[{"device_id":"4567","device_type":"cdef"},{"device_id":"1234","device_type":"abcd"}]}'

		assert_response :success
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'invalid start' do
		get :index, params: { start: 'invalid' }

		expected_resp = '{"error":"Start must be an integer greater than 1."}'

		assert_response :bad_request
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'too low start' do
		get :index, params: { start: 0 }

		expected_resp = '{"error":"Start must be an integer greater than 1."}'

		assert_response :bad_request
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'invalid limit' do
		get :index, params: { limit: 'invalid' }

		expected_resp = '{"error":"Limit must be an integer between 1 and 500."}'

		assert_response :bad_request
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'too low limit' do
		get :index, params: { limit: 0 }

		expected_resp = '{"error":"Limit must be an integer between 1 and 500."}'

		assert_response :bad_request
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'too high limit' do
		get :index, params: { limit: 501 }

		expected_resp = '{"error":"Limit must be an integer between 1 and 500."}'

		assert_response :bad_request
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'lower limit' do
		get :index, params: { limit: 1 }

		# expected_resp = '{"devices":[{"device_id":"12a4","device_type":"1234"}]}'
		expected_resp = '{"devices":[{"device_id":"4567","device_type":"cdef"}]}'

		assert_response :success
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'upper limit' do
		get :index, params: { limit: 500 }

		expected_resp = '{"devices":[{"device_id":"4567","device_type":"cdef"},{"device_id":"1234","device_type":"abcd"}]}'

		assert_response :success
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end

	test 'get device' do
		get :show, params: { id: 1234 }

		expected_resp = '{"device_id":"1234","device_type":"abcd"}'

		assert_response :success
		assert_equal 'application/json', response.content_type
		assert_equal expected_resp, response.body
	end
end