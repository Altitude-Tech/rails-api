require 'test_helper'

module V1
  class DevicesControllerTest < ActionController::TestCase
    ##
    # Data for creating a new device
    ##
    CREATE_DATA = {
      device_type: Device::TYPE_MAIN_HASH
    }.freeze

    ##
    # Test success of the `register` method.
    ##
    test 'register success' do
      login
      device = create_device
      data = { identity: device.identity }

      post :register, body: data.to_json
      res = JSON.parse response.body

      assert res.key? 'token'
      assert res.key? 'identity'
      assert_equal res['identity'], device.identity

      token = Token.find res['token']

      assert token.active?
      assert token.expires.nil?

      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for `register` when the user is not logged in.
    ##
    test 'register not logged in' do
      device = create_device
      data = { identity: device.identity }
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      post :register, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for `register` when no device could be found for the given `identity`.
    ##
    test 'register device not found' do
      login
      create_device
      data = { identity: 'invalid' }
      expected = {
        error: 104,
        message: '"identity" not found.',
        status: 400
      }

      post :register, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for `register` for a device that is already registered.
    ##
    test 'register device already registered' do
      login
      device = create_device
      device.register! User.first!.group
      data = { identity: device.identity }
      expected = {
        error: 107,
        message: 'Device is already registered.',
        status: 400
      }

      post :register, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    private

    ##
    # Create a new device for registering.
    ##
    def create_device
      data = CREATE_DATA.deep_dup
      device = Device.create! data

      return device
    end

    ##
    # Set a session cookie to fake being logged in.
    ##
    def login
      user = User.first!
      token = user.authenticate! 'password'

      cookies.signed[:session] = token.token
    end
  end
end
