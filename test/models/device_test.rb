require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  ##
  # Data for creating a new devoce entry.
  ##
  CREATE_DATA = {
    device_type: Device::TYPE_MAIN_HASH
  }.freeze

  ##
  # Test sucess of the `create!` method.
  ##
  test 'create! success' do
    data = CREATE_DATA.deep_dup

    Device.create! data
  end

  ##
  # Test error handling for the `create!` method with a non-unique `identity` attribute.
  ##
  test 'create! non-unique identity' do
    device = Device.first!
    data = CREATE_DATA.deep_dup
    data[:identity] = device.identity

    assert_raises ActiveRecord::RecordInvalid do
      Device.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `identity` attribute.
  ##
  test 'create! invalid identity' do
    data = CREATE_DATA.deep_dup
    data[:identity] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Device.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a missing `device_type` attribute.
  ##
  test 'create! missing device_type' do
    data = CREATE_DATA.deep_dup
    data.delete(:device_type)

    assert_raises ActiveRecord::RecordInvalid do
      Device.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `device_type` attribute.
  ##
  test 'create! invalid device_type' do
    data = CREATE_DATA.deep_dup
    data[:device_type] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Device.create! data
    end
  end

  ##
  # Test success of the `register!` method.
  ##
  test 'register! success' do
    group = Group.first!
    device = Device.first!

    token = device.register! group

    assert_equal token.token, device.token.token
    assert device.token.active?
  end

  ##
  # Test error handling for the `register!` method with an already registered device.
  ##
  test 'register! already registered' do
    group = Group.first!
    device = Device.first!

    device.register! group

    assert_raises Record::DeviceRegistrationError do
      device.register!
    end
  end

  ##
  # Test error handling for the `register!` method with a missing group.
  ##
  test 'register! missing group' do
    device = Device.first!

    assert_raises Record::DeviceRegistrationError do
      device.register!
    end
  end

  ##
  # Test error handling for the `register!` method with a not found group.
  ##
  test 'register! not found group' do
    device = Device.first!

    assert_raises Record::DeviceRegistrationError do
      device.register! 3
    end
  end

  ##
  # Test success of `authenticate!` method.
  ##
  test 'authenticate! success' do
    group = Group.first!
    device = Device.first!
    token = device.register! group

    device.authenticate! token.token
  end

  ##
  # Test error handling for the `authenticate!` method with a missing `token` parameter.
  ##
  test 'authenticate! missing token' do
    group = Group.first!
    device = Device.first!
    device.register! group

    assert_raises Record::DeviceAuthError do
      device.authenticate!
    end
  end

  ##
  # Test error handling for the `authenticate!` method with a missing `token` parameter.
  ##
  test 'authenticate! invalid token' do
    group = Group.first!
    device = Device.first!
    device.register! group

    assert_raises Record::DeviceAuthError do
      device.authenticate! 'invalid'
    end
  end
end
