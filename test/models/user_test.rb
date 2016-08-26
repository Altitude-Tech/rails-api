##
#
##

require 'test_helper'

##
#
##
class UserTest < ActiveSupport::TestCase
  ##
  #
  ##
  BASE_DATA =  {
    name: 'test user',
    email: 'test@example.com',
    password: 'password'
  }.freeze

  ##
  # Test successful creation
  ##
  test 'create success' do
    data = BASE_DATA.deep_dup

    User.create!(data)
  end

  ##
  # Test error handling of no password
  ##
  test 'create no password' do
    data = BASE_DATA.deep_dup
    data.delete(:password)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test error handling password below minimum length
  ##
  test 'create too short password' do
    data = BASE_DATA.deep_dup
    data[:password] = 'short'

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test error handling for invalid email address
  ##
  test 'create invalid email' do
    data = BASE_DATA.deep_dup
    data[:email] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test error handling for missing email address
  ##
  test 'create missing email' do
    data = BASE_DATA.deep_dup
    data.delete(:email)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test error handling for missing name
  ##
  test 'create missing name' do
    data = BASE_DATA.deep_dup
    data.delete(:name)

    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!(data)
    end
  end

  ##
  # Test successful authentication of user
  ##
  test 'authenticate successful' do
    password = 'password'
    user = User.find_by_email('bert@example.com')

    actual = user.authenticate(password)

    assert_instance_of(User, actual)
    assert_equal('Bert Sesame', actual.name)
  end

  ##
  # Test incorrect authentication of user
  ##
  test 'authenticate incorrect' do
    password = 'invalid'
    user = User.find_by_email('bert@example.com')

    actual = user.authenticate(password)

    assert_equal(false, actual)
  end

  ##
  # Test successful authentication of user with error raising method
  ##
  test 'authenticate successful with error' do
    password = 'password'
    user = User.find_by_email('bert@example.com')

    actual = user.authenticate!(password)

    assert_instance_of(User, actual)
    assert_equal('Bert Sesame', actual.name)
  end

  ##
  # Test incorrect authentication of user with error raising method
  ##
  test 'authenticate incorrect with error' do
    password = 'invalid'
    user = User.find_by_email('bert@example.com')

    assert_raises(ArgumentError) do
      user.authenticate!(password)
    end
  end
end
