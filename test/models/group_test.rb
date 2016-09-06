require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  ##
  # Test getting all members of a group
  ##
  test 'get members of group' do
    email = User.first!.email
    group = Group.find(1)

    assert_equal(1, group.user.length)
    assert_equal(email, group.user[0].email)
  end

  ##
  # Test getting the admin of a group
  ##
  test 'get admin of group' do
    email = User.first!.email
    group = Group.find(1)

    assert_equal(email, group.admin.email)
  end

  ##
  # Test successful group creation
  ##
  test 'create group success' do
    user = new_user
    email = user.email

    group = Group.create!(admin: user)

    assert_equal(1, group.user.length)
    assert_equal(email, group.user[0].email)
  end

  ##
  # Test error handling for creation with missing admin
  ##
  test 'create group missing admin' do
    assert_raises(ActiveRecord::RecordNotFound) do
      Group.create!
    end
  end

  ##
  # Test error handling for creation with too long group name
  ##
  test 'create group too long name' do
    user = new_user
    name = 'x' * 256

    assert_raises(ActiveRecord::RecordInvalid) do
      Group.create!(admin: user, name: name)
    end
  end

  ##
  # Test error handling for creation with an admin already part of a group
  ##
  test 'create group in use admin' do
    user = User.first!

    assert_raises(ArgumentError) do
      Group.create!(admin: user)
    end
  end

  private

  ##
  # Create a new user in the database
  ##
  def new_user
    data = {
      name: 'test user',
      email: 'test@example.com',
      password: 'password'
    }

    user = User.create!(data)
    return user
  end
end
