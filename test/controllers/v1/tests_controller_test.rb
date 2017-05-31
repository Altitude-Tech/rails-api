require 'test_helper'

module V1
  class TestsControllerTest < ActionController::TestCase
    ##
    #
    ##
    test 'fake session' do
      cookies.signed[:session] = 'invalid'
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      post :create

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    #
    ##
    test 'invalid json' do
      data = 'invalid'
      expected = {
        error: 109,
        message: '743: unexpected token at \'invalid\'',
        status: 400
      }

      login
      post :create, body: data

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    #
    ##
    test 'raise unhandled error' do
      expected = {
        error: 500,
        message: 'An unhandled exception occurred.',
        status: 500
      }

      post :unhandled_error

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :internal_server_error
    end

    ##
    # TODO: Fix this - code coverage claims it's never being called
    ##
    test 'options' do
      expected = ''

      login
      process :create, http_method = 'OPTIONS'

      puts response.headers
      assert_equal expected, response.body
      assert_response :no_content
    end

    ##
    #
    ##
    test 'normalise_keys single layer' do
      data = {
        key: 'value'
      }
      expected = {
        result: 'success'
      }

      login
      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    #
    ##
    test 'normalise_keys nested hash' do
      data = {
        key: {
          key1: 'value1',
          key2: 'value2'
        }
      }
      expected = {
        result: 'success'
      }

      login
      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    #
    ##
    test 'normalise_keys nested array' do
      data = {
        key: [1, 2, 3, 4, 5, 6]
      }
      expected = {
        result: 'success'
      }

      login
      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end
  end
end
