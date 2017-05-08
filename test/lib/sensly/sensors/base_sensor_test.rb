##
# Tests for the BaseSensor class.
##

require 'test_helper'
require 'sensly/sensors/base_sensor'

class BaseSensorTest < MiniTest::Test
  ##
  # Test for an error when a negative ADC value is used.
  ##
  def test_below_min_adc
    assert_raises Sensly::ADCValueOutOfRangeError do
      Sensly::BaseSensor.new(-1.0)
    end
  end

  ##
  # Test for an error when an ADC value above 4095 is used.
  ##
  def test_above_max_adc
    assert_raises Sensly::ADCValueOutOfRangeError do
      Sensly::BaseSensor.new(4096.0)
    end
  end
end
