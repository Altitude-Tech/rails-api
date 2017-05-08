##
# Tests for the PMSensor class.
##

require 'test_helper'
require 'sensly/sensors/pm_sensor'

class PMSensorTest < MiniTest::Test
  ##
  # Test PM density calculation based on data from the sensor.
  ##
  def test_pm_density
    adc_value = 92
    expected = 63.1062

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density.round(4)
  end

  ##
  # Test the density calculation with an ADC value that converts to a voltage.
  # lower than the minimum threshold
  ##
  def test_below_no_dust_voltage
    adc_value = 56
    expected = 0

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density
  end

  ##
  # Test the density calculation with an ADC value that converts to a voltage
  # above the minimum threshold.
  ##
  def test_above_no_dust_voltage
    adc_value = 57
    expected = 1.0549

    sensor = Sensly::PMSensor.new(adc_value)

    assert_equal expected, sensor.pm_density.round(4)
  end
end
