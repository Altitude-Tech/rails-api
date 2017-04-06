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
    # values based on sample data set (thus effectively random)
    # TODO: Get sample data for this
    adc_value = 2000
    expected = 0

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density
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
  def test_below_no_dust_voltage
    adc_value = 57
    expected = 1.0549

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density.round(4)
  end
end
