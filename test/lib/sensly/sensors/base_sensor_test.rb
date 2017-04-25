##
#
##

require 'test_helper'
require 'sensly/sensors/base_sensor'

class BaseSensorTest < MiniTest::Test
  ##
  #
  ##
  def test_below_min_adc
    assert_raises Sensly::ADCValueOutOfRangeError do
      Sensly::BaseSensor.new(-1.0)
    end
  end

  ##
  #
  ##
  def test_above_max_adc
    assert_raises Sensly::ADCValueOutOfRangeError do
      Sensly::BaseSensor.new(4096.0)
    end
  end
end
