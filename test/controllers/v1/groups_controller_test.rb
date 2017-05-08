require 'test_helper'

module V1
  class GroupsControllerTest < ActionController::TestCase
    ##
    # Data for creating a new group.
    ##
    CREATE_DATA = {
      name: 'Group 3'
    }.freeze

    ##
    # Data for creating new users.
    ##
    USER2_DATA = {
      name: 'Bert',
      email: 'bert@example.com',
      password: 'password'
    }.freeze

    ##
    # Test success of the `add_users` method.
    ##
    test 'add_user success' do
      data = USER_DATA.deep_dup
      User.create! data

      data.delete(:name)
      data.delete(:password)
      data = add_token data

      expected = {
        result: 'success'
      }

      login User.first!
      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `add_users` method with a missing `token` attribute.
    ##
    test 'add_user missing token' do
      data = USER_DATA.deep_dup
      User.create! data

      data.delete(:name)
      data.delete(:password)

      expected = {
        error: 112,
        message: 'Invalid or missing token.',
        status: 400
      }

      login User.first!
      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `add_users` method when not logged in.
    ##
    test 'add_user not logged in' do
      data = add_token email: USER_DATA[:email]
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `add_users` method when the logged in user is not a group admin.
    ##
    test 'add_user not admin' do
      user = User.create! USER_DATA.deep_dup
      user.group = Group.first!.id
      data = USER2_DATA.deep_dup
      User.create! data

      data.delete(:name)
      data.delete(:password)
      data = add_token data

      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      login user
      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `add_users` method when the `email` parameter is missing.
    ##
    test 'add_user email missing' do
      User.create! USER_DATA.deep_dup
      data = add_token
      expected = {
        error: 104,
        message: '"email" not found.',
        status: 400
      }

      login User.first!
      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `add_users` method when the `email` parameter value is not found.
    ##
    test 'add_user email not found' do
      User.create! USER_DATA.deep_dup
      data = add_token email: 'notfound@example.com'
      expected = {
        error: 104,
        message: '"email" not found.',
        status: 400
      }

      login User.first!
      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `add_users` method when the user is already in a group.
    ##
    test 'add_user already in group' do
      user = User.first!
      data = add_token email: user.email
      expected = {
        error: 106,
        message: 'User is already a member of a group.',
        status: 400
      }

      login User.find 2
      post :add_user, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of the create method.
    ##
    test 'create success' do
      data = add_token CREATE_DATA.deep_dup
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
    # Test error handling of the `create` method wioth a missing token.
    ##
    test 'create missing token' do
      data = CREATE_DATA.deep_dup
      expected = {
        error: 112,
        message: 'Invalid or missing token.',
        status: 400
      }

      login
      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method when not logged in.
    ##
    test 'create not logged in' do
      data = add_token CREATE_DATA.deep_dup
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
    # Test error handling of the `create` method when the logged in user is already in a group.
    ##
    test 'create already in group' do
      data = add_token CREATE_DATA.deep_dup
      expected = {
        error: 106,
        message: 'User is already a member of a group.',
        status: 400
      }

      login User.first!
      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling of the `create` method when the `name` parameter is too long.
    ##
    test 'create too long group name' do
      data = add_token CREATE_DATA.deep_dup
      data[:name] = 'x' * 256
      expected = {
        error: 103,
        message: '"name" is too long (maximum is 255 characters).',
        user_message: 'Name is too long (maximum is 255 characters).',
        status: 400
      }

      login
      post :create, body: data.to_json

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test success of the `create` method when the `name` parameter is at the upper limit.
    ##
    test 'create upper limit group name' do
      data = add_token CREATE_DATA.deep_dup
      data.delete(:name)
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
    # Test success of the the `create` method when the `name` parameter is missing.
    ##
    test 'create missing group name' do
      data = add_token CREATE_DATA.deep_dup
      data.delete(:name)
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
    # Test success of the `show` method.
    ##
    test 'show success' do
      data = add_token CREATE_DATA.deep_dup
      expected = {
        name: 'Group 3',
        admin: 'bob@example.com',
        users: [
          {
            name: 'Bob',
            email: 'bob@example.com'
          }
        ],
        devices: []
      }

      login
      post :create, body: data.to_json
      get :show

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :ok
    end

    ##
    # Test error handling for the `show` method when not logged in.
    ##
    test 'show not logged in' do
      data = CREATE_DATA.deep_dup
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      post :create, body: data.to_json
      get :show

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end

    ##
    # Test error handling for the `show` method for a non-member.
    ##
    test 'show non-member' do
      expected = {
        error: 101,
        message: 'Not authorised.',
        status: 400
      }

      login
      get :show

      assert_equal expected.to_json, response.body
      assert_equal JSON_TYPE, response.content_type
      assert_response :bad_request
    end
  end
end
