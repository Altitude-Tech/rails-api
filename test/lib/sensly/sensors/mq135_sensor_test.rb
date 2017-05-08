##
# Tests for the MQ135Sensor class.
# Tests largely focus on 'bands' which are the ranges across different gases can be detected.
##

require 'test_helper'
require 'sensly/sensors/mq135_sensor'

class MQ135SensorTest < MiniTest::Test
  #
  # Values to be used as constants for the tests.
  # Based on values from a sample data set.
  ##
  R0 = 2786.3375
  TEMP = 20.785436042
  HUMIDITY = 27.1676259197

  ##
  # ADC values that correspond to RSR0 values for the gases detected by the MQ135 sensor.
  ##
  ABOVE_UPPER = 2280 # RSR0 2.8524

  BAND1_UPPER = 2281 # RSR0 2.8496
  BAND1_LOWER = 2376 # RSR0 2.5924

  BAND2_UPPER = 2377 # RSR0 2.5898
  BAND2_LOWER = 2473 # RSR0 2.3501

  BAND3_UPPER = 2474 # RSR0 2.3477
  BAND3_LOWER = 2671 # RSR0 1.9103

  BAND4_UPPER = 2672 # RSR0 1.9082
  BAND4_LOWER = 2825 # RSR0 1.6108

  BAND5_UPPER = 2826 # RSR0 1.6090
  BAND5_LOWER = 2880 # RSR0 1.5116

  BAND6_UPPER = 2881 # RSR0 1.5099
  BAND6_LOWER = 2921 # RSR0 1.4401

  BAND7_UPPER = 2922 # RSR0 1.4384
  BAND7_LOWER = 3347 # RSR0 0.8008

  BAND8_UPPER = 3348 # RSR0 0.7995
  BAND8_LOWER = 3520 # RSR0 0.5853

  BELOW_LOWER = 3521 # RSR0 0.5841

  ##
  # Tests the conversion based on data from a sample data set.
  ##
  def test_rs_r0_ratio
    # values based on sample data set (thus effectively random)
    adc_value = 2189
    rs_ro_ratio = 3.1250
    corr_rs_ro_ratio = 3.1199

    sensor = Sensly::MQ135Sensor.new(adc_value, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    expected_gases = [].to_set
    gases = [].to_set

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected_gases, gases
  end

  ##
  # Test conversion for relative humidity above 65%.
  ##
  def test_above_65_rh
    adc_value = 2189
    rs_ro_ratio = 3.1250
    corr_rs_ro_ratio = 3.3771

    sensor = Sensly::MQ135Sensor.new(adc_value, R0, TEMP, 70.0)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    expected_gases = [].to_set
    gases = [].to_set

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected_gases, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 2.85.
  ##
  def test_above_upper
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 2.8570
    corr_rs_ro_ratio = 2.8524

    sensor = Sensly::MQ135Sensor.new(ABOVE_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 2.85.
  ##
  def test_band1_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 9.8149].to_set
    ].to_set
    rs_ro_ratio = 2.8542
    corr_rs_ro_ratio = 2.8496

    sensor = Sensly::MQ135Sensor.new(BAND1_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 2.59.
  ##
  def test_band1_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 14.7025].to_set
    ].to_set
    rs_ro_ratio = 2.5965
    corr_rs_ro_ratio = 2.5924

    sensor = Sensly::MQ135Sensor.new(BAND1_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 2.59.
  ##
  def test_band2_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 14.7656].to_set,
      [Sensly::NAME_NH3, 9.9414].to_set
    ].to_set
    rs_ro_ratio = 2.5939
    corr_rs_ro_ratio = 2.5898

    sensor = Sensly::MQ135Sensor.new(BAND2_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 2.35.
  ##
  def test_band2_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 22.3558].to_set,
      [Sensly::NAME_NH3, 12.6189].to_set
    ].to_set
    rs_ro_ratio = 2.3539
    corr_rs_ro_ratio = 2.3501

    sensor = Sensly::MQ135Sensor.new(BAND2_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 2.35.
  ##
  def test_band3_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 22.4535].to_set,
      [Sensly::NAME_NH3, 12.6506].to_set,
      [Sensly::NAME_CO2, 10.1265].to_set
    ].to_set
    rs_ro_ratio = 2.3515
    corr_rs_ro_ratio = 2.3477

    sensor = Sensly::MQ135Sensor.new(BAND3_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 1.91.
  ##
  def test_band3_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 54.1788].to_set,
      [Sensly::NAME_NH3, 20.9921].to_set,
      [Sensly::NAME_CO2, 18.0303].to_set
    ].to_set
    rs_ro_ratio = 1.9134
    corr_rs_ro_ratio = 1.9103

    sensor = Sensly::MQ135Sensor.new(BAND3_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 1.91.
  ##
  def test_band4_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 54.4286].to_set,
      [Sensly::NAME_NH3, 21.0477].to_set,
      [Sensly::NAME_CO2, 18.0847].to_set,
      [Sensly::NAME_ETHANOL, 10.1542].to_set
    ].to_set
    rs_ro_ratio = 1.9113
    corr_rs_ro_ratio = 1.9082

    sensor = Sensly::MQ135Sensor.new(BAND4_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 1.61.
  ##
  def test_band4_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 112.247].to_set,
      [Sensly::NAME_NH3, 31.9109].to_set,
      [Sensly::NAME_CO2, 29.0529].to_set,
      [Sensly::NAME_ETHANOL, 17.3494].to_set
    ].to_set
    rs_ro_ratio = 1.6134
    corr_rs_ro_ratio = 1.6108

    sensor = Sensly::MQ135Sensor.new(BAND4_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 1.61.
  ##
  def test_band5_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 112.7957].to_set,
      [Sensly::NAME_NH3, 32.0005].to_set,
      [Sensly::NAME_CO2, 29.1459].to_set,
      [Sensly::NAME_ETHANOL, 17.4122].to_set,
      [Sensly::NAME_METHYL, 10.0675].to_set
    ].to_set
    rs_ro_ratio = 1.6116
    corr_rs_ro_ratio = 1.6090

    sensor = Sensly::MQ135Sensor.new(BAND5_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 1.51.
  ##
  def test_band5_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 147.2611].to_set,
      [Sensly::NAME_NH3, 37.3022].to_set,
      [Sensly::NAME_CO2, 34.7069].to_set,
      [Sensly::NAME_ETHANOL, 21.2104].to_set,
      [Sensly::NAME_METHYL, 12.3377].to_set
    ].to_set
    rs_ro_ratio = 1.5141
    corr_rs_ro_ratio = 1.5116

    sensor = Sensly::MQ135Sensor.new(BAND5_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 1.51.
  ##
  def test_band6_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 147.9994].to_set,
      [Sensly::NAME_NH3, 37.4096].to_set,
      [Sensly::NAME_CO2, 34.8208].to_set,
      [Sensly::NAME_ETHANOL, 21.2891].to_set,
      [Sensly::NAME_METHYL, 12.3848].to_set,
      [Sensly::NAME_ACETONE, 10.1524].to_set
    ].to_set
    rs_ro_ratio = 1.5123
    corr_rs_ro_ratio = 1.5099

    sensor = Sensly::MQ135Sensor.new(BAND6_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 1.44.
  ##
  def test_band6_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 181.1348].to_set,
      [Sensly::NAME_NH3, 42.0175].to_set,
      [Sensly::NAME_CO2, 39.7470].to_set,
      [Sensly::NAME_ETHANOL, 24.7225].to_set,
      [Sensly::NAME_METHYL, 14.4480].to_set,
      [Sensly::NAME_ACETONE, 11.8044].to_set
    ].to_set
    rs_ro_ratio = 1.4425
    corr_rs_ro_ratio = 1.4401

    sensor = Sensly::MQ135Sensor.new(BAND6_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 1.44.
  ##
  def test_band7_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_NH3, 42.1410].to_set,
      [Sensly::NAME_CO2, 39.8800].to_set,
      [Sensly::NAME_ETHANOL, 24.8161].to_set,
      [Sensly::NAME_METHYL, 14.5043].to_set,
      [Sensly::NAME_ACETONE, 11.8494].to_set
    ].to_set
    rs_ro_ratio = 1.4407
    corr_rs_ro_ratio = 1.4384

    sensor = Sensly::MQ135Sensor.new(BAND7_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 0.8.
  ##
  def test_band7_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_NH3, 177.6204].to_set,
      [Sensly::NAME_CO2, 205.3348].to_set,
      [Sensly::NAME_ETHANOL, 158.1084].to_set,
      [Sensly::NAME_METHYL, 97.7836].to_set,
      [Sensly::NAME_ACETONE, 76.6625].to_set
    ].to_set
    rs_ro_ratio = 0.8021
    corr_rs_ro_ratio = 0.8008

    sensor = Sensly::MQ135Sensor.new(BAND7_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 0.8.
  ##
  def test_band8_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_NH3, 178.3358].to_set,
      [Sensly::NAME_ETHANOL, 158.9286].to_set,
      [Sensly::NAME_METHYL, 98.3064].to_set,
      [Sensly::NAME_ACETONE, 77.0635].to_set
    ].to_set
    rs_ro_ratio = 0.8008
    corr_rs_ro_ratio = 0.7995

    sensor = Sensly::MQ135Sensor.new(BAND8_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 0.585.
  ##
  def test_band8_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_NH3, 383.5592].to_set,
      [Sensly::NAME_ETHANOL, 425.9065].to_set,
      [Sensly::NAME_METHYL, 271.4945].to_set,
      [Sensly::NAME_ACETONE, 208.2134].to_set
    ].to_set
    rs_ro_ratio = 0.5863
    corr_rs_ro_ratio = 0.5853

    sensor = Sensly::MQ135Sensor.new(BAND8_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 0.585.
  ##
  def test_below_lower
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 0.5851
    corr_rs_ro_ratio = 0.5841

    sensor = Sensly::MQ135Sensor.new(BELOW_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      gases.add [gas[:name], gas[:ppm].round(4)].to_set
    end

    assert_equal expected, gases
  end
end
