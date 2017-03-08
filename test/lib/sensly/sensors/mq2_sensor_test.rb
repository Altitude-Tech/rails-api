##
#
##

require 'test_helper'
require 'sensly/sensors/mq2_sensor'

class MQ2SensorTest < MiniTest::Test
  ##
  #
  ##
  R0 = 3120.5010
  TEMP = 21.0
  HUMIDITY = 22.0

  ##
  # ADC values that correspond to RSR0 values for the gases detected by the MQ2 sensor.
  # The RSR0 values used to generate these ADC values are noted next to each ADC value.
  ##
  ABOVE_UPPER = 1335 # RSR0 5.21

  BAND1_UPPER = 1354 # RSR0 5.2
  BAND1_LOWER = 1854 # RSR0 3.1

  BAND2_UPPER = 1888 # RSR0 3
  BAND2_LOWER = 1939 # RSR0 2.851

  BAND3_UPPER = 1941 # RSR0 2.85
  BAND3_LOWER = 2247 # RSR0 2.11

  BAND4_UPPER = 2253 # RSR0 2.1
  BAND4_LOWER = 2401 # RSR0 1.81

  BAND5_UPPER = 2407 # RSR0 1.8
  BAND5_LOWER = 2516 # RSR0 1.61

  BAND6_UPPER = 2523 # RSR0 1.6
  BAND6_LOWER = 3226 # RSR0 0.691

  BAND7_UPPER = 3228 # RSR0 0.69
  BAND7_LOWER = 3622 # RSR0 0.3351

  BAND8_UPPER = 3623 # RSR0 0.335
  BAND8_LOWER = 3718 # RSR0 0.26

  BELOW_LOWER = 3719 # RSR0 0.259

  ##
  #
  ##
  def test_rs_r0_ratio
    # values based on sample data set (thus effectively random)
    adc_value = 1119
    expected = 3.56

    sensor = Sensly::MQ2Sensor.new(adc_value, R0, TEMP, HUMIDITY)

    assert_equal expected, sensor.corr_rs_r0_ratio.round(2)
  end

  ##
  # Test for the correct identification of carbon monoxide only with an RSR0 ratio just below
  # 5.2.
  ##
  def test_band1_upper
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO)
    ].to_set

    Sensly::MQ2Sensor.new(BAND1_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 1 upper: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  # Test for the correct identification of carbon monoxide only with an RSR0 ratio just above
  # 3.
  ##
  def test_band1_lower
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO)
    ].to_set

    Sensly::MQ2Sensor.new(BAND1_LOWER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 1 lower: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  # Test for the correct identification of carbon monoxide and methane with an RSR0 ratio just
  # below 3.
  ##
  def test_band2_upper
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO),
      Sensly.gas_name(Sensly::GAS_CH4)
    ].to_set

    Sensly::MQ2Sensor.new(BAND2_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 2 upper: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band2_lower
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO),
      Sensly.gas_name(Sensly::GAS_CH4)
    ].to_set

    Sensly::MQ2Sensor.new(BAND2_LOWER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 2 lower: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band3_upper
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO),
      Sensly.gas_name(Sensly::GAS_CH4),
      Sensly.gas_name(Sensly::GAS_ALCOHOL)
    ].to_set

    Sensly::MQ2Sensor.new(BAND3_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 3: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band4_upper
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO),
      Sensly.gas_name(Sensly::GAS_CH4),
      Sensly.gas_name(Sensly::GAS_ALCOHOL),
      Sensly.gas_name(Sensly::GAS_H2)
    ].to_set

    Sensly::MQ2Sensor.new(BAND4_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 4: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band5_upper
    gases = [].to_set
    expected = [
      Sensly.gas_name(Sensly::GAS_CO),
      Sensly.gas_name(Sensly::GAS_CH4),
      Sensly.gas_name(Sensly::GAS_ALCOHOL),
      Sensly.gas_name(Sensly::GAS_H2),
      Sensly.gas_name(Sensly::GAS_PROPANE),
      Sensly.gas_name(Sensly::GAS_LPG)
    ].to_set

    Sensly::MQ2Sensor.new(BAND5_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 5: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band6_upper
    gases = [].to_set
    expected = [
      Sensly::gas_name(Sensly::GAS_CH4),
      Sensly::gas_name(Sensly::GAS_ALCOHOL),
      Sensly::gas_name(Sensly::GAS_H2),
      Sensly::gas_name(Sensly::GAS_PROPANE),
      Sensly::gas_name(Sensly::GAS_LPG)
    ].to_set

    Sensly::MQ2Sensor.new(BAND6_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 6: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band7_upper
    gases = [].to_set
    expected = [
      Sensly::gas_name(Sensly::GAS_H2),
      Sensly::gas_name(Sensly::GAS_PROPANE),
      Sensly::gas_name(Sensly::GAS_LPG)
    ].to_set

    Sensly::MQ2Sensor.new(BAND7_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 7: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  #
  ##
  def test_band8_upper
    gases = [].to_set
    expected = [
      Sensly::gas_name(Sensly::GAS_PROPANE),
      Sensly::gas_name(Sensly::GAS_LPG)
    ].to_set

    Sensly::MQ2Sensor.new(BAND8_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
      puts "Band 8: #{gas[:name]} :: #{gas[:ppm]} :: #{gas[:rs_ro]}"
    end

    assert_equal expected, gases
  end

  ##
  # Test for no gases detected for an RSR0 ratio above 5.2.
  ##
  def test_above_upper_limit
    gases = [].to_set
    expected = [].to_set

    Sensly::MQ2Sensor.new(ABOVE_UPPER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
    end

    assert_equal expected, gases
  end

  ##
  # Test for no gases detected for an RSR0 ratio below 0.26
  ##
  def test_below_lower_limit
    gases = [].to_set
    expected = [].to_set

    Sensly::MQ2Sensor.new(BELOW_LOWER, R0, TEMP, HUMIDITY).gases do |gas|
      gases.add gas[:name]
    end

    assert_equal expected, gases
  end
end
