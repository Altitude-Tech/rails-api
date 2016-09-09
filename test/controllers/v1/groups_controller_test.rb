##
# DataController tests
##

require 'test_helper'

module V1
  class GroupsControllerTest < ActionController::TestCase
    ##
    #
    ##
    USER_DATA = {
      name: 'Bill',
      email: 'bill@example.com',
      password: 'password'
    }.freeze

    ##
    #
    ##
    test 'create success' do
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      set_session_token!
      post(:create)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    #
    ##
    test 'create success with name' do
      data = {
        name: 'example'
      }
      expected = {
        result: I18n.t('controller.v1.message.success')
      }

      set_session_token!
      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:ok)
    end

    ##
    #
    ##
    test 'create too long name' do
      data = {
        name: 'x' * 256
      }
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.invalid_value', key: 'name'),
        status: 400
      }

      set_session_token!
      post(:create, body: data.to_json)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'create not logged in' do
      expected = {
        error: 1,
        message: I18n.t('controller.v1.error.logged_out'),
        status: 400
      }

      post(:create)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    ##
    #
    ##
    test 'create user in group' do
      expected = {
        error: 1,
        # @todo fix message
        message: '',
        status: 400
      }

      set_session_token!(User.first!)
      post(:create)

      assert_equal(expected.to_json, response.body)
      assert_equal('application/json', response.content_type)
      assert_response(:bad_request)
    end

    private

    ##
    #
    ##
    def create_user!
      user = User.create!(USER_DATA.deep_dup)
      return user
    end

    ##
    #
    ##
    def set_session_token!(user = nil)
      user ||= create_user!
      user.create_session_token!

      cookies.signed[:session] = user.session_token.token
    end

    ##
    #
    ##
    def create_group!
      user = create_user!
      set_session_token!(user)

      group = Group.create!(admin: user)

      return group
    end
  end
end
