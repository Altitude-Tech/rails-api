##
# Device model tests
##

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  BASE_DATA = {
    device_id: '1452',
    device_type: Device::TYPE_TEST
  }.freeze

  ##
  # Test error handling of invalid value for device id
  ##
  test 'invalid device_id' do
    data = BASE_DATA.deep_dup
    data[:device_id] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(data)
    end
  end

  ##
  # Test error handling for duplicate creation
  #
  # Uses fixtures as original record
  ##
  test 'duplicate device_id' do
    data = BASE_DATA.deep_dup
    data[:device_id] = '1234'

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(data)
    end
  end

  ##
  # Test error handling for missing device type
  ##
  test 'missing device_id' do
    data = BASE_DATA.deep_dup
    data.delete(:device_id)

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(device_type: 'abcd')
    end
  end

  ##
  # Test error handling of invalid value for device type
  ##
  test 'invalid device_type' do
    data = BASE_DATA.deep_dup
    data[:device_type] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(device_id: '1452', device_type: 'invalid')
    end
  end

  ##
  # Test error handling of missing device type
  ##
  test 'missing device_type' do
    data = BASE_DATA.deep_dup
    data.delete(:device_type)

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(device_id: '1452')
    end
  end

  ##
  # Test error handling of missing device id and device type
  ##
  test 'missing device_id and device_type' do
    data = {}

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(data)
    end
  end

  ##
  # Test error handling of test device in production
  ##
  test 'production device test' do
    cur_env = ENV['RAILS_ENV']
    ENV['RAILS_ENV'] = 'production'

    data = BASE_DATA.deep_dup

    assert_raises(ActiveRecord::RecordInvalid) do
      Device.create!(data)
    end

    ENV['RAILS_ENV'] = cur_env
  end

  ##
  # Test successful creation
  ##
  test 'successful create' do
    data = BASE_DATA.deep_dup

    Device.create!(data)
  end
end
