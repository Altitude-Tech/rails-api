require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  ##
  # Data to use for creating groups.
  ##
  CREATE_DATA = {
    name: 'Group 3'
  }.freeze

  ##
  # Data for creating a new user.
  ##
  USER_DATA = {
    name: 'Bob',
    email: 'bob@example.com',
    password: 'password'
  }.freeze

  ##
  # Test success of the `create!` method.
  ##
  test 'create! success' do
    data = create_data

    group = Group.create! data

    assert_equal group.admin.group.id, group.id
  end

  ##
  # Test success of the `create!` method with a missing `name` attribute.
  ##
  test 'create! success missing name' do
    data = create_data
    data.delete(:name)

    Group.create! data
  end

  ##
  # Test error handling for the `create!` method with a too long `name` attribute.
  ##
  test 'create! too long name' do
    data = create_data
    data[:name] = 'x' * 256

    assert_raises ActiveRecord::RecordInvalid do
      Group.create! data
    end
  end

  ##
  # Test success of the `create!` method with a `name` attribute length at the upper limit.
  ##
  test 'create! success upper limit name' do
    data = create_data
    data[:name] = 'x' * 255

    Group.create! data
  end

  ##
  # Test error handling of the `create!` method with a missing `admin` attribute.
  ##
  test 'create! missing admin' do
    data = create_data
    data.delete(:admin)

    assert_raises ActiveRecord::RecordNotFound do
      Group.create! data
    end
  end

  ##
  # Test error handling of the `create!` method with an invalid missing `admin` attribute.
  ##
  test 'create! invalid admin' do
    data = create_data
    data[:admin] = 'invalid'

    assert_raises ActiveRecord::RecordNotFound do
      Group.create! data
    end
  end

  ##
  # Test error handling of the `create!` method with a not found `admin` attribute.
  ##
  test 'create! not found admin' do
    data = create_data
    data[:admin] = 4

    assert_raises ActiveRecord::RecordNotFound do
      Group.create! data
    end
  end

  ##
  # Test error handling of the `create!` method with an in-group `admin` attribute.
  ##
  test 'create! in group admin' do
    data = create_data
    data[:admin] = User.first!

    assert_raises Record::GroupMemberError do
      Group.create! data
    end
  end

  ##
  # Test success of the `users` method.
  ##
  test 'users success' do
    data = create_data
    group = Group.create! data

    users = group.users

    assert 1, users.length
    assert data[:admin].id, users.first.id
  end

  ##
  # Test success of `devices` method with no devices registered to the group.
  ##
  test 'devices success empty' do
    data = create_data
    group = Group.create! data

    devices = group.devices

    assert 0, devices.length
  end

  ##
  # Test success of `devices` method with one device registered to the group.
  ##
  test 'devices success one' do
    data = create_data
    group = Group.create! data
    device = Device.first

    device.register! group
    devices = group.devices

    assert 1, devices.length
    assert devices.first.is_a? Device
  end

  private

  ##
  # Get a set of data to be used for creating a new group.
  ##
  def create_data
    admin = User.create! USER_DATA

    data = CREATE_DATA.deep_dup
    data[:admin] = admin

    return data
  end
end
