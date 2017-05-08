require 'test_helper'

class RawDatumTest < ActiveSupport::TestCase
  ##
  # Data to create a new data point with.
  ##
  CREATE_DATA = {
    sensor_type: RawDatum::SENSOR_MQ2_HASH,
    sensor_error: 0,
    sensor_data: 0,
    sensor_r0: 0,
    log_time: Time.now.utc.to_i,
    temperature: 20.0,
    pressure: 1000,
    humidity: 0
  }.freeze

  ##
  # Test success of the `create!` method.
  ##
  test 'create! success' do
    data = create_data

    RawDatum.create! data
  end

  ##
  # Test error handling for the `create!` method with a missing `device_id` attribute.
  ##
  test 'create! missing device_id' do
    data = create_data
    data.delete :device_id

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `device_id` attribute.
  ##
  test 'create! invalid device_id' do
    data = create_data
    data[:device_id] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a missing `sensor_type` attribute.
  ##
  test 'create! missing sensor_type' do
    data = create_data
    data.delete :sensor_type

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `sensor_type` attribute.
  ##
  test 'create! invalid sensor_type' do
    data = create_data
    data[:sensor_type] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a missing `sensor_error` attribute.
  ##
  test 'create! missing sensor_error' do
    data = create_data
    data.delete :sensor_error

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `sensor_error` attribute.
  ##
  test 'create! invalid sensor_error' do
    data = create_data
    data[:sensor_error] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too low `sensor_error` attribute.
  ##
  test 'create! too low sensor_error' do
    data = create_data
    data[:sensor_error] = -0.1

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too high `sensor_error` attribute.
  ##
  test 'create! too high sensor_error' do
    data = create_data
    data[:sensor_error] = 1.1

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test success of `create!` method with a `sensor_error` attribute at the lower limit.
  ##
  test 'create! lower limit sensor error' do
    data = create_data
    data[:sensor_error] = 0.0

    RawDatum.create! data
  end

  ##
  # Test success of `create!` method with a `sensor_error` attribute at the upper limit.
  ##
  test 'create! upper limit sensor_error' do
    data = create_data
    data[:sensor_error] = 1.0

    RawDatum.create! data
  end

  ##
  # Test error handling for the `create!` method with a missing `sensor_data` attribute.
  ##
  test 'create! missing sensor_data' do
    data = create_data
    data.delete :sensor_data

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `sensor_data` attribute.
  ##
  test 'create! invalid sensor_data' do
    data = create_data
    data[:sensor_data] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too low `sensor_data` attribute.
  ##
  test 'create! too low sensor_data' do
    data = create_data
    data[:sensor_data] = -1

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too high `sensor_data` attribute.
  ##
  test 'create! too high sensor_data' do
    data = create_data
    data[:sensor_data] = 4096

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test success of `create!` method with a `sensor_data` attribute at the lower limit.
  ##
  test 'create! lower limit sensor_data' do
    data = create_data
    data[:sensor_data] = 0

    RawDatum.create! data
  end

  ##
  # Test success of `create!` method with a `sensor_data` attribute at the upper limit.
  ##
  test 'create! upper limit sensor_data' do
    data = create_data
    data[:sensor_data] = 4095

    RawDatum.create! data
  end

  ##
  #  Test error handling for the `create!` method with a non-integer `sensor_data` attribute.
  ##
  test 'create! non-integer sensor_data' do
    data = create_data
    data[:sensor_data] = 1.1

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a missing `log_time` attribute.
  ##
  test 'create! missing log_time' do
    data = create_data
    data.delete :log_time

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `log_time` attribute.
  ##
  test 'create! invalid log_time' do
    data = create_data
    data[:log_time] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too low `log_time` attribute.
  ##
  test 'create! too low log_time' do
    data = create_data
    data[:log_time] = (Time.now.utc - 31.days).to_i

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too high `log_time` attribute.
  ##
  test 'create! too high log_time' do
    data = create_data
    data[:log_time] = (Time.now.utc + 1.day).to_i

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test success of `create!` method with a `log_time` attribute at the lower limit.
  ##
  test 'create! lower limit log_time' do
    data = create_data
    data[:log_time] = (Time.now.utc - 29.days).to_i

    RawDatum.create! data
  end

  ##
  # Test success of `create!` method with a `log_time` attribute at the upper limit.
  ##
  test 'create! upper limit log_time' do
    data = create_data
    data[:log_time] = (Time.now.utc - 5.minutes).to_i

    RawDatum.create! data
  end

  ##
  # Test error handling for the `create!` method with a missing `temperature` attribute.
  ##
  test 'create! missing temperature' do
    data = create_data
    data.delete :temperature

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `temperature` attribute.
  ##
  test 'create! invalid temperature' do
    data = create_data
    data[:temperature] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a missing `pressure` attribute.
  ##
  test 'create! missing pressure' do
    data = create_data
    data.delete :pressure

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `pressure` attribute.
  ##
  test 'create! invalid pressure' do
    data = create_data
    data[:pressure] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a missing `humidity` attribute.
  ##
  test 'create! missing humidity' do
    data = create_data
    data.delete :humidity

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with an invalid `humidity` attribute.
  ##
  test 'create! invalid humidity' do
    data = create_data
    data[:humidity] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too low `humidity` limit.
  ##
  test 'create! too low humidity' do
    data = create_data
    data[:humidity] = -0.1

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test error handling for the `create!` method with a too high `humidity` attribute.
  ##
  test 'create! too high humidity' do
    data = create_data
    data[:humidity] = 100.1

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test success of `create!` method with a `humidity` attribute at the lower limit.
  ##
  test 'create! lower limit humidity' do
    data = create_data
    data[:humidity] = 0

    RawDatum.create! data
  end

  ##
  # Test success of `create!` method with a `humidity` attribute at the upper limit.
  ##
  test 'create! upper limit humidity' do
    data = create_data
    data[:humidity] = 100

    RawDatum.create! data
  end

  ##
  # Tests error handling for `create!` method with a missing `sensor_r0` attribute.
  ##
  test 'create! missing sensor_r0' do
    data = create_data
    data.delete(:sensor_r0)

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Tests error handling for `create!` method with an invalid `sensor_r0` attribute.
  ##
  test 'create! invalid sensor_r0' do
    data = create_data
    data[:sensor_r0] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  ##
  # Test success of `create!` method for a PM sensor.
  ##
  test 'create! pm sensor' do
    data = create_data
    data[:sensor_type] = RawDatum::SENSOR_PM_HASH
    data.delete(:sensor_r0)

    RawDatum.create! data
  end

  ##
  # Test error handling of `create! method for a PM sensor with a `sensor_r0` attribute set.
  ##
  test 'create! pm sensor with sensor_r0' do
    data = create_data
    data[:sensor_type] = RawDatum::SENSOR_PM_HASH

    assert_raises ActiveRecord::RecordInvalid do
      RawDatum.create! data
    end
  end

  private

  ##
  # Helper method for getting data to create a new data point with.
  ##
  def create_data
    device = Device.first!
    data = CREATE_DATA.deep_dup
    data[:device_id] = device.id

    return data
  end
end
