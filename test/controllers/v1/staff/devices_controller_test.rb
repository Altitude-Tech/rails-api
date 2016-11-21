require 'test_helper'

module V1
  module Staff
    class DevicesControllerTest < ActionController::TestCase
      ##
      # Data to be used when creating new devices.
      ##
      CREATE_DATA = {
        device_type: Device::TYPE_MAIN_HASH
      }.freeze

      ##
      # Test success of the `create` method.
      ##
      test 'create success' do
        login_staff

        data = CREATE_DATA.deep_dup

        post :create, body: data.to_json
        res = JSON.parse response.body

        assert res.key? 'identity'
        assert 30, res['identity'].length
        assert_equal JSON_TYPE, response.content_type
        assert_response :ok
      end

      ##
      # Test error handling for the `create` method with a missing `device_type` parameter.
      ##
      test 'create missing device_type' do
        login_staff

        data = CREATE_DATA.deep_dup
        data.delete :device_type
        expected = {
          error: 103,
          message: '"device_type" is an invalid value.',
          user_message: 'Device type is an invalid value.',
          status: 400
        }

        post :create, body: data.to_json

        assert_equal expected.to_json, response.body
        assert_equal JSON_TYPE, response.content_type
        assert_response :bad_request
      end

      ##
      # Test error handling for the `create` method with an invalid `device_type` parameter.
      ##
      test 'create invalid device_type' do
        login_staff

        data = CREATE_DATA.deep_dup
        data[:device_type] = 'invalid'
        expected = {
          error: 103,
          message: '"device_type" is an invalid value.',
          user_message: 'Device type is an invalid value.',
          status: 400
        }

        post :create, body: data.to_json

        assert_equal expected.to_json, response.body
        assert_equal JSON_TYPE, response.content_type
        assert_response :bad_request
      end

      ##
      # Test error handling for the `create` method when not logged in.
      ##
      test 'create not logged in' do
        data = CREATE_DATA.deep_dup
        expected = {
          error: 101,
          message: 'Not authorised.',
          status: 400
        }

        post :create, body: data.to_json

        assert_equal expected.to_json, response.body
        assert_equal JSON_TYPE, response.content_type
        assert_response :bad_request
      end

      ##
      # Test error handling for the `create` method when logged in as a non-admin.
      ##
      test 'create not staff' do
        login

        data = CREATE_DATA.deep_dup
        expected = {
          error: 101,
          message: 'Not authorised.',
          status: 400
        }

        post :create, body: data.to_json
        res = JSON.parse response.body

        assert_equal expected.to_json, response.body
        assert_equal JSON_TYPE, response.content_type
        assert_response :bad_request
      end

      private

      ##
      # Set a session cookie to fake being logged in as staff.
      ##
      def login_staff
        user = User.first!
        token = user.authenticate! 'password'

        cookies.signed[:session] = token.token
      end

      ##
      # Set a session cookie to fake being logged in.
      ##
      def login
        user = User.find(2)
        token = user.authenticate! 'password'

        cookies.signed[:session] = token.token
      end
    end
  end
end
