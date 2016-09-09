##
# UsersController tests
##

require 'test_helper'

module V1
  class UsersControllerTest < ActionController::TestCase
    ##
    # Base data hash for create tests
    ##
    CREATE_DATA = {
      name: 'test user',
      email: 'test@example.com',
      password: 'password'
    }.freeze

    ##
    # Base data hash for login tests
    ##
    LOGIN_DATA = {
      email: 'bert@example.com',
      password: 'password'
    }.freeze

    ##
    # Base data hash for reset_password tests
    ##
    RESET_PASSWORD_DATA = {
      email: 'bert@example.com',
      password: 'password',
      new_password: 'new_password'
    }.freeze

    ##
    # Test create user success
    ##
    test 'create user success' do
      data = CREATE_DATA.deep_dup
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for create user with invalid email
    ##
    test 'create user invalid email' do
      data = CREATE_DATA.deep_dup
      data[:email] = 'invalid'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'email'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for create user with missing email
    ##
    test 'create user missing email' do
      data = CREATE_DATA.deep_dup
      data.delete(:email)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'email'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for create user with in-use email
    ##
    test 'create user in use email' do
      user = User.first!
      data = CREATE_DATA.deep_dup
      data[:email] = user.email
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'email'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for create user with missing name
    ##
    test 'create user missing name' do
      data = CREATE_DATA.deep_dup
      data.delete(:name)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'name'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for create user with invalid password
    ##
    test 'create user invalid password' do
      data = CREATE_DATA.deep_dup
      data[:password] = 'short'
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'password'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for create with missing password
    ##
    test 'create user missing password' do
      data = CREATE_DATA.deep_dup
      data.delete(:password)
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'password'),
        status: 400
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test show success
    ##
    test 'show user success' do
      expected = {
        name: 'Bert Sesame',
        email: 'bert@example.com'
      }

      session_token!
      get(:show, params: { email: 'bert@example.com' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for show with invalid email
    ##
    test 'show user invalid email' do
      args = { model: 'user', key: 'email', value: 'invalid' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      get(:show, params: { email: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test login success
    ##
    test 'login user success' do
      data = LOGIN_DATA.deep_dup
      now = Time.now.utc
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)

      session_cookie = cookies.signed[:session]

      # test expiry of session token
      token = Token.find_by_token!(session_cookie)
      diff = ((token.expires - now) / 1.hour).round

      assert_equal(6, diff)

      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for login with invalid email
    ##
    test 'login user invalid email' do
      data = LOGIN_DATA.deep_dup
      data[:email] = 'invalid'
      args = { model: 'user', key: 'email', value: 'invalid' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for login with missing email
    ##
    test 'login user missing email' do
      data = LOGIN_DATA.deep_dup
      data.delete(:email)
      args = { model: 'user', key: 'email', value: '' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for login with incorrect email
    ##
    test 'login user incorrect password' do
      data = LOGIN_DATA.deep_dup
      data[:password] = 'incorrect'
      expected = {
        error: 1,
        message: I18n.t('models.users.error.password'),
        status: 400
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for login with missing password
    ##
    test 'login user missing password' do
      data = LOGIN_DATA.deep_dup
      data.delete(:password)
      expected = {
        error: 1,
        message: I18n.t('models.users.error.password'),
        status: 400
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test reset_password success
    ##
    test 'reset_password user success' do
      data = RESET_PASSWORD_DATA.deep_dup
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      patch(:reset_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for reset_password with missing email
    ##
    test 'reset_password user missing email' do
      data = RESET_PASSWORD_DATA.deep_dup
      data.delete(:email)
      args = { model: 'user', key: 'email', value: '' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      patch(:reset_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for reset_password with invalid email
    ##
    test 'reset_password user not found email' do
      data = RESET_PASSWORD_DATA.deep_dup
      data[:email] = 'invalid'
      args = { model: 'user', key: 'email', value: 'invalid' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.not_found', args),
        status: 400
      }

      patch(:reset_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test update success with new name
    ##
    test 'update user name success' do
      params = { email: 'bert@example.com' }
      data = { name: 'Bob' }
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      session_token!
      patch(:update, params: params, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for update with no session token
    ##
    test 'update no session token' do
      params = { email: 'bert@example.com' }
      data = { name: 'Bob' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.unauthorised'),
        status: 400
      }

      patch(:update, params: params, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end


    ##
    # Test error handling for update with invalid
    ##
    test 'update invalid session token' do
      params = { email: 'bert@example.com' }
      data = { name: 'Bob' }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.unauthorised'),
        status: 400
      }

      session_token!('invalid')
      patch(:update, params: params, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for update with password
    ##
    test 'update user password' do
      params = { email: 'bert@example.com' }
      data = { password: 'password' }
      expected = {
        error: 1,
        message: I18n.t('models.users.error.not_supported', key: 'password'),
        status: 400
      }

      session_token!
      patch(:update, params: params, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for update with password_digest
    ##
    test 'update user password_digest' do
      params = { email: 'bert@example.com' }
      data = { password_digest: 'password_digest' }
      expected = {
        error: 1,
        message: I18n.t('models.users.error.not_supported', key: 'password_digest'),
        status: 400
      }

      session_token!
      patch(:update, params: params, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for update with random attribute
    ##
    test 'update user random attribute' do
      params = { email: 'bert@example.com' }
      data = { random: 'value' }
      expected = {
        error: 1,
        message: I18n.t('models.users.error.not_supported', key: 'random'),
        status: 400
      }

      session_token!
      patch(:update, params: params, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'logout valid session_token' do
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      session_token!
      post(:logout)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    #
    ##
    test 'logout invalid session_token' do
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      session_token!('invalid')
      post(:logout)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    #
    ##
    test 'logout missing session_token' do
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      cookies.delete(:session_token)
      post(:logout)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    private

    ##
    #
    ##
    def session_token!(token = nil)
      if token.nil?
        user = User.first!
        user.create_session_token!
        token = user.session_token.token
      end

      cookies.signed[:session_token] = token
    end
  end
end
