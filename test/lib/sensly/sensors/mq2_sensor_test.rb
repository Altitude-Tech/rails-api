##
# Tests for the MQ2Sensor class.
# Tests largely focus on 'bands' which are the ranges across different gases can be detected.
##

require 'test_helper'
require 'sensly/sensors/mq2_sensor'

class MQ2SensorTest < MiniTest::Test
  ##
  # Values to be used as constants for the tests.
  # Based on values from a sample data set.
  ##
  R0 = 3120.5010
  TEMP = 20.785436042
  HUMIDITY = 27.1676259197

  ##
  # ADC values that correspond to RSR0 values for the gases detected by the MQ2 sensor.
  ##
  ABOVE_UPPER = 1255 # RSR0 5.2035

  BAND1_UPPER = 1256 # RSR0 5.1976
  BAND1_LOWER = 1776 # RSR0 3.0025

  BAND2_UPPER = 1777 # RSR0 2.9995
  BAND2_LOWER = 1828 # RSR0 2.8517

  BAND3_UPPER = 1829 # RSR0 2.8488
  BAND3_LOWER = 2140 # RSR0 2.1007

  BAND4_UPPER = 2141 # RSR0 2.0986
  BAND4_LOWER = 2296 # RSR0 1.8017

  BAND5_UPPER = 2297 # RSR0 1.7999
  BAND5_LOWER = 2414 # RSR0 1.6012

  BAND6_UPPER = 2415 # RSR0 1.5996
  BAND6_LOWER = 3149 # RSR0 0.6908

  BAND7_UPPER = 3150 # RSR0 0.6898
  BAND7_LOWER = 3574 # RSR0 0.3352

  BAND8_UPPER = 3575 # RSR0 0.3345
  BAND8_LOWER = 3679 # RSR0 0.2600

  BELOW_LOWER = 3680 # RSR0 0.2293

  ##
  # Tests the conversion based on data from a sample data set.
  ##
  def test_rs_ro_ratio
    # values based on sample data set (thus effectively random)
    adc_value = 2787
    rs_ro_ratio = 1.5040
    corr_rs_ro_ratio = 1.0792

    sensor = Sensly::MQ2Sensor.new(adc_value, R0, TEMP, HUMIDITY)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    expected_gases = [
      [Sensly::NAME_CH4, 3421.7756].to_set,
      [Sensly::NAME_LPG, 549.2121].to_set,
      [Sensly::NAME_H2, 888.9265].to_set,
      [Sensly::NAME_PROPANE, 595.2799].to_set,
      [Sensly::NAME_ALCOHOL, 3171.6116].to_set
    ].to_set
    gases = [].to_set

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected_gases, gases
  end

  ##
  # Test conversion for relative humidity above 60%.
  ##
  def test_above_60_rh
    adc_value = 2787
    rs_ro_ratio = 1.5040
    corr_rs_ro_ratio = 1.4433

    sensor = Sensly::MQ2Sensor.new(adc_value, R0, TEMP, 65.0)

    assert_equal rs_ro_ratio, sensor.rs_ro_ratio.round(4)
    assert_equal corr_rs_ro_ratio, sensor.corr_rs_ro_ratio.round(4)

    expected_gases = [
      [Sensly::NAME_CH4, 1569.1369].to_set,
      [Sensly::NAME_LPG, 301.5205].to_set,
      [Sensly::NAME_H2, 488.565].to_set,
      [Sensly::NAME_PROPANE, 325.0401].to_set,
      [Sensly::NAME_ALCOHOL, 1439.5267].to_set
    ].to_set
    gases = [].to_set

    sensor.gases do |gas|
      if gas[:conc_ppm] > 0
        gases.add [gas[:name], gas[:conc_ppm].round(4)].to_set
      end
    end

    assert_equal expected_gases, gases
  end

  ##
  # Test conversion with an RSR0 ratio above 5.2.
  ##
  def test_above_upper_limit
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 7.2519
    corr_rs_ro_ratio = 5.2035

    sensor = Sensly::MQ2Sensor.new(ABOVE_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 5.2.
  ##
  def test_band1_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 210.5475].to_set
    ].to_set
    rs_ro_ratio = 7.2435
    corr_rs_ro_ratio = 5.1976

    sensor = Sensly::MQ2Sensor.new(BAND1_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 3.
  ##
  def test_band1_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 1228.3664].to_set
    ].to_set
    rs_ro_ratio = 4.1844
    corr_rs_ro_ratio = 3.0025

    sensor = Sensly::MQ2Sensor.new(BAND1_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 3.
  ##
  def test_band2_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 1232.2979].to_set,
      [Sensly::NAME_CH4, 220.6464].to_set
    ].to_set
    rs_ro_ratio = 4.1802
    corr_rs_ro_ratio = 2.9995

    sensor = Sensly::MQ2Sensor.new(BAND2_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 2.85.
  ##
  def test_band2_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 1449.6641].to_set,
      [Sensly::NAME_CH4, 252.6748].to_set
    ].to_set
    rs_ro_ratio = 3.9742
    corr_rs_ro_ratio = 2.8517

    sensor = Sensly::MQ2Sensor.new(BAND2_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 2.85.
  ##
  def test_band3_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 1454.2754].to_set,
      [Sensly::NAME_CH4, 253.3452].to_set,
      [Sensly::NAME_ALCOHOL, 226.8911].to_set
    ].to_set
    rs_ro_ratio = 3.9703
    corr_rs_ro_ratio = 2.8488

    sensor = Sensly::MQ2Sensor.new(BAND3_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 2.1.
  ##
  def test_band3_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 3871.8145].to_set,
      [Sensly::NAME_CH4, 573.5048].to_set,
      [Sensly::NAME_ALCOHOL, 519.1892].to_set
    ].to_set
    rs_ro_ratio = 2.9276
    corr_rs_ro_ratio = 2.1007

    sensor = Sensly::MQ2Sensor.new(BAND3_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 2.1.
  ##
  def test_band4_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 3884.0145].to_set,
      [Sensly::NAME_CH4, 575.0122].to_set,
      [Sensly::NAME_ALCOHOL, 520.5718].to_set,
      [Sensly::NAME_H2, 226.0518].to_set
    ].to_set
    rs_ro_ratio = 2.9247
    corr_rs_ro_ratio = 2.0986

    sensor = Sensly::MQ2Sensor.new(BAND4_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 1.8.
  ##
  def test_band4_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 6341.7703].to_set,
      [Sensly::NAME_CH4, 865.6372].to_set,
      [Sensly::NAME_ALCOHOL, 787.9248].to_set,
      [Sensly::NAME_H2, 309.4572].to_set
    ].to_set
    rs_ro_ratio = 2.5109
    corr_rs_ro_ratio = 1.8017

    sensor = Sensly::MQ2Sensor.new(BAND4_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 1.8.
  ##
  def test_band5_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 6362.0116].to_set,
      [Sensly::NAME_CH4, 867.9419].to_set,
      [Sensly::NAME_ALCOHOL, 790.0503].to_set,
      [Sensly::NAME_H2, 310.0895].to_set,
      [Sensly::NAME_PROPANE, 205.2787].to_set,
      [Sensly::NAME_LPG, 191.2129].to_set
    ].to_set
    rs_ro_ratio = 2.5084
    corr_rs_ro_ratio = 1.7999

    sensor = Sensly::MQ2Sensor.new(BAND5_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 1.6.
  ##
  def test_band5_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CO, 9265.4197].to_set,
      [Sensly::NAME_CH4, 1187.7261].to_set,
      [Sensly::NAME_ALCOHOL, 1085.6220].to_set,
      [Sensly::NAME_H2, 394.5214].to_set,
      [Sensly::NAME_PROPANE, 261.8607].to_set,
      [Sensly::NAME_LPG, 243.3849].to_set
    ].to_set
    rs_ro_ratio = 2.2315
    corr_rs_ro_ratio = 1.6012

    sensor = Sensly::MQ2Sensor.new(BAND5_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 1.6.
  ##
  def test_band6_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_CH4, 1190.9449].to_set,
      [Sensly::NAME_ALCOHOL, 1088.6030].to_set,
      [Sensly::NAME_H2, 395.342].to_set,
      [Sensly::NAME_PROPANE, 262.4113].to_set,
      [Sensly::NAME_LPG, 243.8921].to_set
    ].to_set
    rs_ro_ratio = 2.2293
    corr_rs_ro_ratio = 1.5996

    sensor = Sensly::MQ2Sensor.new(BAND6_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 0.69.
  ##
  def test_band6_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_CH4, 11_319.756].to_set,
      [Sensly::NAME_ALCOHOL, 10_659.1940].to_set,
      [Sensly::NAME_H2, 2227.2198].to_set,
      [Sensly::NAME_PROPANE, 1506.5304].to_set,
      [Sensly::NAME_LPG, 1378.3947].to_set
    ].to_set
    rs_ro_ratio = 0.9627
    corr_rs_ro_ratio = 0.6908

    sensor = Sensly::MQ2Sensor.new(BAND6_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 0.69.
  ##
  def test_band7_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_H2, 2233.5344].to_set,
      [Sensly::NAME_PROPANE, 1510.8484].to_set,
      [Sensly::NAME_LPG, 1382.3099].to_set
    ].to_set
    rs_ro_ratio = 0.9614
    corr_rs_ro_ratio = 0.6898

    sensor = Sensly::MQ2Sensor.new(BAND7_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 0.335.
  ##
  def test_band7_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_H2, 9869.5865].to_set,
      [Sensly::NAME_PROPANE, 6785.4641].to_set,
      [Sensly::NAME_LPG, 6124.9534].to_set
    ].to_set
    rs_ro_ratio = 0.4672
    corr_rs_ro_ratio = 0.3352

    sensor = Sensly::MQ2Sensor.new(BAND7_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 0.335.
  ##
  def test_band8_upper
    gases = [].to_set
    expected = [
      [Sensly::NAME_PROPANE, 6816.6191].to_set,
      [Sensly::NAME_LPG, 6152.8225].to_set
    ].to_set
    rs_ro_ratio = 0.4661
    corr_rs_ro_ratio = 0.3345

    sensor = Sensly::MQ2Sensor.new(BAND8_UPPER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio above 0.26.
  ##
  def test_band8_lower
    gases = [].to_set
    expected = [
      [Sensly::NAME_PROPANE, 11_512.9816].to_set,
      [Sensly::NAME_LPG, 10_343.0367].to_set
    ].to_set
    rs_ro_ratio = 0.3624
    corr_rs_ro_ratio = 0.2600

    sensor = Sensly::MQ2Sensor.new(BAND8_LOWER, R0, TEMP, HUMIDITY)

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
  # Test conversion with an RSR0 ratio below 0.26.
  ##
  def test_below_lower_limit
    gases = [].to_set
    expected = [].to_set
    rs_ro_ratio = 0.3614
    corr_rs_ro_ratio = 0.2593

    sensor = Sensly::MQ2Sensor.new(BELOW_LOWER, R0, TEMP, HUMIDITY)

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
