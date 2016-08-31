##
# Datum model tests
##

require 'test_helper'

class DatumTest < ActiveSupport::TestCase
  ##
  #
  ##
  BASE_DATA = {
    sensor_type: Datum::SENSOR_MQ2,
    sensor_error: 0.2,
    sensor_data: 10,
    log_time: Time.now.to_i,
    temperature: 25.37,
    pressure: 1009.30,
    humidity: 63.12
  }.freeze

  ##
  # Test error handling for invalid sensor type
  ##
  test 'invalid sensor_type' do
    data = base_data
    data[:sensor_type] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing sensor type
  ##
  test 'missing sensor type' do
    data = base_data
    data.delete(:sensor_type)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too high sensor error
  ##
  test 'too high sensor error' do
    data = base_data
    data[:sensor_error] = 2

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too low sensor error
  ##
  test 'too low sensor error' do
    data = base_data
    data[:sensor_error] = -1

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for sensor error
  ##
  test 'invalid sensor error' do
    data = base_data
    data[:sensor_error] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing sensor error
  ##
  test 'missing sensor error' do
    data = base_data
    data.delete(:sensor_error)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too low sensor data
  ##
  test 'too low sensor data' do
    data = base_data
    data[:sensor_data] = -1

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too high sensor data
  ##
  test 'too high sensor data' do
    data = base_data
    data[:sensor_data] = 4096

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for sensor data
  ##
  test 'invalid sensor data' do
    data = base_data
    data[:sensor_data] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test behaviour for integer float sensor data
  ##
  test 'integer float sensor data' do
    data = base_data
    data[:sensor_data] = 100.0

    Datum.create!(data)
  end

  ##
  # Test error handling for integer float as a string sensor data
  ##
  test 'integer float string sensor data' do
    data = base_data
    data[:sensor_data] = '100.0'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for non integer float sensor data
  ##
  test 'non integer float sensor data' do
    data = base_data
    data[:sensor_data] = 100.5

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for non integer float as a string sensor data
  ##
  test 'non integer float string sensor data' do
    data = base_data
    data[:sensor_data] = '100.5'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing sensor data
  ##
  test 'missing sensor data' do
    data = base_data
    data.delete(:sensor_data)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for log time
  ##
  test 'invalid log time' do
    data = base_data
    data[:log_time] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing log time
  ##
  test 'missing log time' do
    data = base_data
    data.delete(:log_time)
    expected = 'Validation failed: Log time must be in unix time in seconds.'

    assert_raises(ActiveRecord::RecordInvalid) do
      begin
        Datum.create!(data)
      rescue ActiveRecord::RecordInvalid => e
        assert_equal(expected, e.message)
        raise e
      end
    end
  end

  ##
  # Test error handling for log time more than 30 days old
  ##
  test 'too low log time' do
    now = Time.now.utc
    data = base_data
    data[:log_time] = now - 31.days
    expected = 'Validation failed: Log time outside permitted limits.'

    assert_raises(ActiveRecord::RecordInvalid) do
      begin
        Datum.create!(data)
      rescue ActiveRecord::RecordInvalid => e
        assert_equal(expected, e.message)
        raise e
      end
    end
  end

  ##
  # Test error handling for log time in the future
  ##
  test 'too high log time' do
    now = Time.now.utc
    data = base_data
    data[:log_time] = now + 1.day
    expected = 'Validation failed: Log time outside permitted limits.'

    assert_raises(ActiveRecord::RecordInvalid) do
      begin
        Datum.create!(data)
      rescue ActiveRecord::RecordInvalid => e
        assert_equal(expected, e.message)
        raise e
      end
    end
  end

  ##
  # Test error handling for unix time in milliseconds
  # Should only accept unix time in seconds
  ##
  test 'invalid millisecond log time' do
    data = base_data
    data[:log_time] = Time.now.to_i * 1000
    expected = 'Validation failed: Log time must be in unix time in seconds.'

    assert_raises(ActiveRecord::RecordInvalid) do
      begin
        Datum.create!(data)
      rescue ActiveRecord::RecordInvalid => e
        assert_equal(expected, e.message)
        raise e
      end
    end
  end

  ##
  # Test error handling for invalid value for device id
  ##
  test 'invalid device id' do
    data = base_data
    data[:device_id] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing device id
  ##
  test 'missing device id' do
    data = base_data
    data.delete(:device_id)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid temperature
  ##
  test 'invalid temperature' do
    data = base_data
    data[:temperature] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing temperature
  ##
  test 'missing temperature' do
    data = base_data
    data.delete(:temperature)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid pressure
  ##
  test 'invalid pressure' do
    data = base_data
    data[:pressure] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing pressure
  ##
  test 'missing pressure' do
    data = base_data
    data.delete(:pressure)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid humidity
  ##
  test 'invalid humidity' do
    data = base_data
    data[:humidity] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing humidity
  ##
  test 'missing humidity' do
    data = base_data
    data.delete(:humidity)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too low humidity
  ##
  test 'too low humidity' do
    data = base_data
    data[:humidity] = -1

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test success for lower limit humidity
  ##
  test 'lower limit humidity' do
    data = base_data
    data[:humidity] = 0

    Datum.create!(data)
  end

  ##
  # Test error handling for too high humidity
  ##
  test 'too high humidity' do
    data = base_data
    data[:humidity] = 101

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test success for upper limit humidity
  ##
  test 'upper limit humidity' do
    data = base_data
    data[:humidity] = 100

    Datum.create!(data)
  end

  ##
  # Test successful creation
  ##
  test 'successful create' do
    data = base_data

    Datum.create!(data)
  end

  private

  ##
  # Helper method for getting data with a valid device id
  #
  # Fixes an issue where if this set of tests is run first
  # then a device is looked up before fixtures are loaded
  # assuming it's defined with `BASE_DATA` above
  #
  # This solves that by lazy loading it per test
  # which sucks, but works
  ##
  def base_data
    device = Device.first!

    data = BASE_DATA.deep_dup
    data[:device_id] = device.id

    return data
  end
end
