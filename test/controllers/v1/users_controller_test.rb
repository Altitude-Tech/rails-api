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
    # Base data hash for change_password tests
    ##
    CHANGE_PASSWORD_DATA = {
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'email')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'email')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'email')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'name')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'password')
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
        error: I18n.t('controller.v1.error.invalid_value', key: 'password')
      }

      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test index for get all records
    ##
    test 'index user get all' do
      expected = {
        users: [
          {
            name: 'Bert Sesame',
            email: 'bert@example.com'
          },
          {
            name: 'Ernie Sesame',
            email: 'ernie@example.com'
          }
        ]
      }

      get(:index)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for index with invalid start param
    ##
    test 'index user invalid start' do
      expected = {
        error: I18n.t('controller.v1_users.error.start')
      }

      get(:index, params: { start: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for index with too low start param
    ##
    test 'index user too low start' do
      expected = {
        error: I18n.t('controller.v1_users.error.start')
      }

      get(:index, params: { start: 0 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for index with out of bounds start param
    ##
    test 'index user out of bounds start' do
      expected = {
        error: I18n.t('controller.v1_users.error.no_more')
      }

      get(:index, params: { start: 3 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for index with invalid limit param
    ##
    test 'index user invalid limit' do
      expected = {
        error: I18n.t('controller.v1_users.error.limit', max: 500)
      }

      get(:index, params: { limit: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for index with too low limit param
    ##
    test 'index user too low limit' do
      expected = {
        error: I18n.t('controller.v1_users.error.limit', max: 500)
      }

      get(:index, params: { limit: 0 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for index with too high limit param
    ##
    test 'index user too high limit' do
      expected = {
        error: I18n.t('controller.v1_users.error.limit', max: 500)
      }

      get(:index, params: { limit: 501 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test index with start param at lower limit
    ##
    test 'index user lower limit' do
      expected = {
        users: [
          {
            name: 'Bert Sesame',
            email: 'bert@example.com'
          }
        ]
      }

      get(:index, params: { limit: 1 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test index with start param at upper limit
    ##
    test 'index user upper limit' do
      expected = {
        users: [
          {
            name: 'Bert Sesame',
            email: 'bert@example.com'
          },
          {
            name: 'Ernie Sesame',
            email: 'ernie@example.com'
          }
        ]
      }

      get(:index, params: { limit: 500 })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test show success
    ##
    test 'show user success' do
      expected = {
        name: 'Bert Sesame',
        email: 'bert@example.com'
      }

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
        error: I18n.t('controller.v1.error.not_found', args)
      }

      get(:show, params: { email: 'invalid' })

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test login success
    ##
    test 'login user success' do
      data = LOGIN_DATA.deep_dup
      expected = {
        session: 'session'
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
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
        error: I18n.t('controller.v1.error.not_found', args)
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test error handling for login with missing email
    ##
    test 'login user missing email' do
      data = LOGIN_DATA.deep_dup
      data.delete(:email)
      args = { model: 'user', key: 'email', value: '' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test error handling for login with incorrect email
    ##
    test 'login user incorrect password' do
      data = LOGIN_DATA.deep_dup
      data[:password] = 'incorrect'
      expected = {
        error: I18n.t('models.users.error.password')
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
        error: I18n.t('models.users.error.password')
      }

      post(:login, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test change_password success
    ##
    test 'change_password user success' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for change_password with missing email
    ##
    test 'change_password user missing email' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      data.delete(:email)
      args = { model: 'user', key: 'email', value: '' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test error handling for change_password with invalid email
    ##
    test 'change_password user not found email' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      data[:email] = 'invalid'
      args = { model: 'user', key: 'email', value: 'invalid' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test error handling for change_passwordwith missing password
    ##
    test 'change_password user missing password' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      data.delete(:password)
      expected = {
        error: I18n.t('models.users.error.password')
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for change_password with incorrect password
    ##
    test 'change_password user incorrect password' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      data[:password] = 'incorrect'
      expected = {
        error: I18n.t('models.users.error.password')
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for change_password with missing new_password
    ##
    test 'change_password user missing new_password' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      data.delete(:new_password)
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'new_password')
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for change_password with invalid new_password
    ##
    test 'change_password user invalid new_password' do
      data = CHANGE_PASSWORD_DATA.deep_dup
      data[:new_password] = 'short'
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'new_password')
      }

      patch(:change_password, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test update_details success with new name
    ##
    test 'update_details user name success' do
      data = {
        email: 'bert@example.com',
        name: 'Bob'
      }
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test update_details success with new email
    ##
    test 'update_details user new_email success' do
      data = {
        email: 'bert@example.com',
        new_email: 'bert@sesame.com'
      }
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    # Test error handling for update_details with not found email
    ##
    test 'update_details user email invalid' do
      data = {
        email: 'invalid',
        new_email: 'bert@sesame.com'
      }
      args = { model: 'user', key: 'email', value: 'invalid' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test error handling for update_details with missing email
    ##
    test 'update_details user email missing' do
      data = {
        new_email: 'bert@sesame.com'
      }
      args = { model: 'user', key: 'email', value: '' }
      expected = {
        error: I18n.t('controller.v1.error.not_found', args)
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:not_found)
    end

    ##
    # Test error handling for update_details with invalid new_email
    ##
    test 'update_details user invalid new_email' do
      data = {
        email: 'bert@example.com',
        new_email: 'invalid'
      }
      expected = {
        error: I18n.t('controller.v1.error.invalid_value', key: 'new_email')
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for update_details with password
    ##
    test 'update_details user password' do
      data = {
        email: 'bert@example.com',
        password: 'password'
      }
      expected = {
        error: I18n.t('models.users.error.not_supported')
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    # Test error handling for update_details with password_digest
    ##
    test 'update_details user password_digest' do
      data = {
        email: 'bert@example.com',
        password_digest: 'password_digest'
      }
      expected = {
        error: I18n.t('models.users.error.password_digest')
      }

      patch(:update_details, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end
  end
end
