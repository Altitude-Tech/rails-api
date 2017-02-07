require 'test_helper'

class UserTest < ActiveSupport::TestCase
  ##
  # Data to use for creating a new user.
  ##
  CREATE_DATA = {
    name: 'Bob',
    email: 'bob@example.com',
    password: 'password'
  }.freeze

  ##
  # Test success of `create!` method.
  ##
  test 'create! success' do
    data = CREATE_DATA.deep_dup

    User.create! data
  end

  ##
  # Test error handling of `create!` method for misssing `name` attribute.
  ##
  test 'create! error name missing' do
    data = CREATE_DATA.deep_dup
    data.delete :name

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for too long `name` attribute.
  ##
  test 'create! error name too long' do
    data = CREATE_DATA.deep_dup
    data[:name] = 'x' * 256

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for misssing `email` attribute.
  ##
  test 'create! error email missing' do
    data = CREATE_DATA.deep_dup
    data.delete :email

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for invalid `email` attribute.
  ##
  test 'create! error email invalid' do
    data = CREATE_DATA.deep_dup
    data[:email] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of create! method for invalid `email` attribute.
  ##
  test 'create! error email invalid (non-string)' do
    data = CREATE_DATA.deep_dup
    data[:email] = 1

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for too long `email` attribute.
  ##
  test 'create! error email too long' do
    data = CREATE_DATA.deep_dup
    data[:email] = 'x@' + ('y' * 254)

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for too short `email` attribute.
  ##
  test 'create! error email too short' do
    data = CREATE_DATA.deep_dup
    data[:email] = '@'

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create` method for in use `email` attribute.
  ##
  test 'create! error email in use' do
    user = User.first!
    data = CREATE_DATA.deep_dup
    data[:email] = user.email

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for missing `password` attribute.
  ##
  test 'create! error password missing' do
    data = CREATE_DATA.deep_dup
    data.delete :password

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for too short `password` attribute.
  ##
  test 'create! error password too short' do
    data = CREATE_DATA.deep_dup
    data[:password] = 'x'

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test error handling of `create!` method for too long `password` attribute.
  ##
  test 'create! error password too long' do
    data = CREATE_DATA.deep_dup
    data[:password] = 'x' * 73

    assert_raises ActiveRecord::RecordInvalid do
      User.create! data
    end
  end

  ##
  # Test success of `create!` method when the `password` attribute
  # is the maximum allowed length.
  #
  # The minimum length is tested in "create! success".
  ##
  test 'create! error password upper limit' do
    data = CREATE_DATA.deep_dup
    data[:password] = 'x' * 72

    User.create! data
  end

  ##
  # Test success of `find_by_email!` method.
  ##
  test 'find_by_email! success' do
    data = CREATE_DATA.deep_dup
    User.create! data

    User.find_by_email! data[:email]
  end

  ##
  # Test error handling for `find_by_email!` for not found `email` attribute.
  ##
  test 'find_by_email! not found' do
    assert_raises ActiveRecord::RecordNotFound do
      User.find_by_email! 'invalid'
    end
  end

  ##
  # Test success of `authenticate!` method.
  ##
  test 'authenticate! success' do
    data = CREATE_DATA.deep_dup
    user = User.create! data

    expected_expires = (Time.now.utc + 6.hours).to_s

    token = user.authenticate! data[:password]

    assert token.is_a? Token
    assert_equal token.token, user.session_token
    assert_equal expected_expires, token.expires.to_s
  end

  ##
  # Test error handling for `authenticate!` methof for incorrect password.
  ##
  test 'authenticate! incorrect password' do
    data = CREATE_DATA.deep_dup
    user = User.create! data

    assert_raises Record::UserAuthError do
      user.authenticate! 'incorrect'
    end
  end

  ##
  # Test sucess of `reset_session_token!` method.
  ##
  test 'reset_session_token! success' do
    data = CREATE_DATA.deep_dup
    user = User.create! data
    token = user.authenticate! data[:password]

    assert_equal user.session_token, token.token
    assert token.active?
    assert token.enabled

    user.reset_session_token!

    # re-find token otherwise it's attributes are cached
    token = Token.find token.token

    assert user.session_token.nil?
    assert_not token.active?
    assert_not token.enabled
  end

  ##
  # Test sucess of `reset_session_token!` method with no `session_token` set.
  ##
  test 'reset_session_token! success no session_token' do
    data = CREATE_DATA.deep_dup
    user = User.create! data

    assert user.session_token.nil?

    user.reset_session_token!

    assert user.session_token.nil?
  end

  ##
  # Test success of adding a user to a group
  ##
  test 'add user to group success' do
    data = CREATE_DATA.deep_dup
    user = User.create! data
    group = Group.first!

    user.update! group: group

    assert user.group.is_a? Group
    assert_equal group.id, user.group.id
  end

  ##
  # Test error handling for adding a user to a group with an invalid group id.
  ##
  test 'add user to group invalid group' do
    data = CREATE_DATA.deep_dup
    user = User.create! data

    assert_raises ActiveRecord::InvalidForeignKey do
      user.update! group: 'invalid'
    end
  end

  ##
  # Test error handling for adding a user to a group with a not found group id.
  ##
  test 'add user to group not found group' do
    data = CREATE_DATA.deep_dup
    user = User.create! data

    assert_raises ActiveRecord::InvalidForeignKey do
      user.update! group: 3
    end
  end

  ##
  # Test error handling for adding a user already in a group to another group.
  ##
  test 'add user in group to group' do
    user = User.find(2)
    group = Group.find(1)

    assert_raises Record::GroupMemberError do
      user.group = group
    end
  end

  ##
  # Test success for updating a user's details.
  ##
  test 'update_details success' do
    user = User.first!
    data = { name: 'Example' }

    user.update_details! data

    assert user.name == 'Example'
  end

  ##
  # Test success for updating a user's details.
  ##
  test 'update_details attribute not whitelisted' do
    user = User.first!
    data = { error: 'Error' }

    assert_raises Record::UpdateError do
      user.update_details! data
    end
  end
end
