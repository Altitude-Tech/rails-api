require 'test_helper'

class DatumTest < ActiveSupport::TestCase
  ##
  # Data to create a new data point with.
  ##
  CREATE_DATA = {
    sensor_type: RawDatum::SENSOR_MQ2_HASH,
    log_time: Time.now.utc.to_i,
    gas: Sensly::GAS_H2,
    conc_ppm: 0.0,
    conc_ugm3: 0.0
  }.freeze

  ##
  #
  ##
  test 'create! success' do
    data = create_data

    Datum.create! data
  end

  ##
  #
  ##
  test 'create! missing device_id' do
    data = create_data
    data.delete(:device_id)

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! invalid device_id' do
    data = create_data
    data[:device_id] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! missing log_time' do
    data = create_data
    data.delete(:log_time)

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! invalid log_time' do
    data = create_data
    data[:log_time] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! too high log_time' do
    data = create_data
    data[:log_time] += 1.day

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! missing gas' do
    data = create_data
    data.delete(:gas)

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! invalid gas' do
    data = create_data
    data[:gas] = 1000

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! missing conc_ppm' do
    data = create_data
    data.delete(:conc_ppm)

    Datum.create! data
  end

  ##
  #
  ##
  test 'create! invalid conc_ppm' do
    data = create_data
    data[:conc_ppm] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! missing conc_ugm3' do
    data = create_data
    data.delete(:conc_ugm3)

    Datum.create! data
  end

  ##
  #
  ##
  test 'create! invalid conc_ugm3' do
    data = create_data
    data[:conc_ppm] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'create! missing conc_ppm and conc_ugm3' do
    data = create_data
    data.delete(:conc_ppm)
    data.delete(:conc_ugm3)

    assert_raises Record::ConcMissingError do
      Datum.create! data
    end
  end

  ##
  #
  ##
  test 'gas_name' do
    datum = Datum.first!

    assert datum.gas, Sensly::GAS_H2
    assert datum.gas_name, 'Hydrogen'
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
