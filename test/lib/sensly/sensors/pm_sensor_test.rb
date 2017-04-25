##
#
##

require 'test_helper'
require 'sensly/sensors/pm_sensor'

class PMSensorTest < MiniTest::Test
  ##
  #
  ##
  def test_pm_density
    adc_value = 92
    expected = 63.1062

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density.round(4)
  end

  ##
  #
  ##
  def test_below_no_dust_voltage
    adc_value = 56
    expected = 0

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density
  end

  ##
  #
  ##
  def test_above_no_dust_voltage
    adc_value = 57
    expected = 1.0549

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density.round(4)
  end
end
