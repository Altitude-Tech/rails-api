##
# Tests for the MQ7Sensor class.
# Tests largely focus on 'bands' which are the ranges across different gases can be detected.
##

require 'test_helper'
require 'sensly/sensors/mq7_sensor'

class MQ7SensorTest < MiniTest::Test
  #
  # Values to be used as constants for the tests.
  # Based on values from a sample data set.
  ##
  R0 = 1258.8822
  TEMP = 20.785436042
  HUMIDITY = 27.1676259197

  ##
  # ADC values that correspond to RSR0 values for the gases detected by the MQ7 sensor.
  ##
  ABOVE_UPPER = 1269 # RSR0 17.0099

  BAND1_UPPER = 1270 # RSR0 16.9905
  BAND1_LOWER = 1381 # RSR0 15.0109

  BAND2_UPPER = 1382 # RSR0 14.9945
  BAND2_LOWER = 1515 # RSR0 13.0076

  BAND3_UPPER = 1516 # RSR0 12.9940
  BAND3_LOWER = 1878 # RSR0 9.0170

  BAND4_UPPER = 1880 # RSR0 8.9993
  BAND4_LOWER = 1908 # RSR0 8.7551

  BAND5_UPPER = 1909 # RSR0 8.7465
  BAND5_LOWER = 2494 # RSR0 4.9033

  BAND6_UPPER = 2495 # RSR0 4.8982
  BAND6_LOWER = 3331 # RSR0 1.7519

  BAND7_UPPER = 3332 # RSR0 1.7491
  BAND7_LOWER = 3479 # RSR0 1.3524

  BAND8_UPPER = 3480 # RSR0 1.3499
  BAND8_LOWER = 4046 # RSR0 0.0925

  BAND9_UPPER = 4047 # RSR0 0.0906
  BAND9_LOWER = 4066 # RSR0 0.0545

  BELOW_LOWER = 4067 # RSR0 0.0526

  ##
  # Tests the conversion based on data from a sample data set.
  ##
  def test_rs_r0_ratio
    # values based on sample data set (thus effectively random)
    adc_value = 927
    rs_ro_ratio = 27.1469
    corr_rs_ro_ratio = 26.1033

    sensor = Sensly::MQ7Sensor.new(adc_value, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    expected_gases = [].to_set
    gases = [].to_set

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected_gases, gases
  end

  ##
  # Test conversion for relative humidity above 65%.
  ##
  def test_above_65_rh
    adc_value = 927
    rs_ro_ratio = 27.1469
    corr_rs_ro_ratio = 31.0955

    sensor = Sensly::MQ7Sensor.new(adc_value, R0, TEMP, 70.0)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    expected_gases = [].to_set
    gases = [].to_set

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected_gases, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 17.
  ##
  def test_above_upper
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 17.6899
    corr_rs_ro_ratio = 17.0099

    sensor = Sensly::MQ7Sensor.new(ABOVE_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 17.
  ##
  def test_band1_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_ALCOHOL, 41.0932].to_set
    ].to_set
    rs_ro_ratio = 17.6697
    corr_rs_ro_ratio = 16.9905

    sensor = Sensly::MQ7Sensor.new(BAND1_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 15.
  ##
  def test_band1_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_ALCOHOL, 272.8808].to_set
    ].to_set
    rs_ro_ratio = 15.6110
    corr_rs_ro_ratio = 15.0109

    sensor = Sensly::MQ7Sensor.new(BAND1_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 15.
  ##
  def test_band2_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_ALCOHOL, 277.4747].to_set,
      [Sensly::NAME_CH4, 67.2368].to_set
    ].to_set
    rs_ro_ratio = 15.5940
    corr_rs_ro_ratio = 14.9945

    sensor = Sensly::MQ7Sensor.new(BAND2_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 13.
  ##
  def test_band2_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_ALCOHOL, 2436.2089].to_set,
      [Sensly::NAME_CH4, 230.6227].to_set
    ].to_set
    rs_ro_ratio = 13.5276
    corr_rs_ro_ratio = 13.0076

    sensor = Sensly::MQ7Sensor.new(BAND2_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 13.
  ##
  def test_band3_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CH4, 232.7270].to_set
    ].to_set
    rs_ro_ratio = 13.5135
    corr_rs_ro_ratio = 12.9940

    sensor = Sensly::MQ7Sensor.new(BAND3_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 9.
  ##
  def test_band3_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CH4, 5530.4790].to_set
    ].to_set

    rs_ro_ratio = 9.3775
    corr_rs_ro_ratio = 9.0170

    sensor = Sensly::MQ7Sensor.new(BAND3_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 9.
  ##
  def test_band4_upper
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 9.3590
    corr_rs_ro_ratio = 8.9993

    sensor = Sensly::MQ7Sensor.new(BAND4_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 8.75.
  ##
  def test_band4_lower
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 9.1051
    corr_rs_ro_ratio = 8.7551

    sensor = Sensly::MQ7Sensor.new(BAND4_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 8.75.
  ##
  def test_band5_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_LPG, 45.5519].to_set
    ].to_set
    rs_ro_ratio = 9.0962
    corr_rs_ro_ratio = 8.7465

    sensor = Sensly::MQ7Sensor.new(BAND5_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 4.9.
  ##
  def test_band5_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_LPG, 3743.7887].to_set
    ].to_set
    rs_ro_ratio = 5.0993
    corr_rs_ro_ratio = 4.9033

    sensor = Sensly::MQ7Sensor.new(BAND5_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 4.9.
  ##
  def test_band6_upper
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 5.0941
    corr_rs_ro_ratio = 4.8982

    sensor = Sensly::MQ7Sensor.new(BAND6_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 1.75.
  ##
  def test_band6_lower
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 1.8219
    corr_rs_ro_ratio = 1.7519

    sensor = Sensly::MQ7Sensor.new(BAND6_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 1.75.
  ##
  def test_band7_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 43.5064].to_set
    ].to_set
    rs_ro_ratio = 1.8190
    corr_rs_ro_ratio = 1.7491

    sensor = Sensly::MQ7Sensor.new(BAND7_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 1.35.
  ##
  def test_band7_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 64.1454].to_set
    ].to_set
    rs_ro_ratio = 1.4065
    corr_rs_ro_ratio = 1.3524

    sensor = Sensly::MQ7Sensor.new(BAND7_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 1.35.
  ##
  def test_band8_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 64.3309].to_set,
      [Sensly::NAME_H2, 49.5005].to_set
    ].to_set
    rs_ro_ratio = 1.4038
    corr_rs_ro_ratio = 1.3499

    sensor = Sensly::MQ7Sensor.new(BAND8_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 0.092.
  ##
  def test_band8_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 3679.4543].to_set,
      [Sensly::NAME_H2, 1884.2706].to_set
    ].to_set
    rs_ro_ratio = 0.0962
    corr_rs_ro_ratio = 0.0925

    sensor = Sensly::MQ7Sensor.new(BAND8_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 0.092.
  ##
  def test_band9_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_H2, 1938.4159].to_set
    ].to_set
    rs_ro_ratio = 0.0942
    corr_rs_ro_ratio = 0.0906

    sensor = Sensly::MQ7Sensor.new(BAND9_UPPER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 0.053.
  ##
  def test_band9_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_H2, 3866.6265].to_set
    ].to_set
    rs_ro_ratio = 0.0567
    corr_rs_ro_ratio = 0.0545

    sensor = Sensly::MQ7Sensor.new(BAND9_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end

  ##
  # Test conversion with an RSR0 ratio below 0.053.
  ##
  def test_below_lower
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 0.0547
    corr_rs_ro_ratio = 0.0526

    sensor = Sensly::MQ7Sensor.new(BELOW_LOWER, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected, gases
  end
end
