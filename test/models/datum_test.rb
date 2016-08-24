##
# Datum model tests
##

require 'test_helper'

class DatumTest < ActiveSupport::TestCase
  BASE_DATA = {
    sensor_type: Datum::SENSOR_MQ2,
    sensor_error: 0.0,
    sensor_data: 1,
    log_time: Time.now.utc.to_s(:db),
    device_id: 1234,
    temperature: 25.37,
    pressure: 1009.30,
    humidity: 63.12
  }.freeze

  ##
  # Test error handling for invalid sensor type
  ##
  test 'invalid sensor_type' do
    data = BASE_DATA.deep_dup
    data[:sensor_type] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing sensor type
  ##
  test 'missing sensor type' do
    data = BASE_DATA.deep_dup
    data.delete(:sensor_type)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too high sensor error
  ##
  test 'too high sensor error' do
    data = BASE_DATA.deep_dup
    data[:sensor_error] = 2

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too low sensor error
  ##
  test 'too low sensor error' do
    data = BASE_DATA.deep_dup
    data[:sensor_error] = -1

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for sensor error
  ##
  test 'invalid sensor error' do
    data = BASE_DATA.deep_dup
    data[:sensor_error] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing sensor error
  ##
  test 'missing sensor error' do
    data = BASE_DATA.deep_dup
    data.delete(:sensor_error)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for too low sensor data
  ##
  test 'too low sensor data' do
    data = BASE_DATA.deep_dup
    data[:sensor_data] = -1

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for sensor data
  ##
  test 'invalid sensor data' do
    data = BASE_DATA.deep_dup
    data[:sensor_data] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing sensor data
  ##
  test 'missing sensor data' do
    data = BASE_DATA.deep_dup
    data.delete(:sensor_data)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for log time
  ##
  test 'invalid log time' do
    data = BASE_DATA.deep_dup
    data[:log_time] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing log time
  ##
  test 'missing log time' do
    data = BASE_DATA.deep_dup
    data.delete(:log_time)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for unix time in milliseconds
  # Should only accept unix time in seconds
  ##
  test 'invalid millisecond log time' do
    device = Device.first!
    time = Time.at(Time.now.to_i * 1000).utc.to_s(:db)

    data = BASE_DATA.deep_dup
    data[:log_time] = time
    data[:device_id] = device.id

    assert_raises(ActiveRecord::StatementInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid value for device id
  ##
  test 'invalid device id' do
    data = BASE_DATA.deep_dup
    data[:device_id] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing device id
  ##
  test 'missing device id' do
    data = BASE_DATA.deep_dup
    data.delete(:device_id)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid temperature
  ##
  test 'invalid temperature' do
    data = BASE_DATA.deep_dup
    data[:temperature] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing temperature
  ##
  test 'missing temperature' do
    data = BASE_DATA.deep_dup
    data.delete(:temperature)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid pressure
  ##
  test 'invalid pressure' do
    data = BASE_DATA.deep_dup
    data[:pressure] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing pressure
  ##
  test 'missing pressure' do
    data = BASE_DATA.deep_dup
    data.delete(:pressure)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for invalid humidity
  ##
  test 'invalid humidity' do
    data = BASE_DATA.deep_dup
    data[:humidity] = 'invalid'

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test error handling for missing humidity
  ##
  test 'missing humidity' do
    data = BASE_DATA.deep_dup
    data.delete(:humidity)

    assert_raises(ActiveRecord::RecordInvalid) do
      Datum.create!(data)
    end
  end

  ##
  # Test successful creation
  ##
  test 'successful create' do
    device = Device.first!

    data = BASE_DATA.deep_dup
    data[:device_id] = device.id

    Datum.create!(data)
  end
end
