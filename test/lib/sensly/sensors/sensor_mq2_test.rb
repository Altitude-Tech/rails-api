##
#
##

require 'test_helper'
require 'sensly/sensors/sensor_mq2'

class SensorMQ2Test < MiniTest::Test

  BAND1_UPPER = 1354 # 5.2
  BAND2_UPPER = 1888 # 3
  BAND3_UPPER = 1941 # 2.85
  BAND4_UPPER = 2252 # 2.1
  BAND5_UPPER = 2407 # 1.8
  BAND6_UPPER = 2523 # 1.6
  BAND7_UPPER = 3228 # 0.69
  BAND8_UPPER = 3623 # 0.335

    ##
    # Test for the correct identification of carbon monoxide only with an RSR0 ratio between
    # 5.2 and 3.
    ##
    def test_band1_success
      gases = []

      Sensly::SensorMQ2(BAND1_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 1
    end

    ##
    # Test for the correct identification of carbon monoxide and methane with an RSR0 ratio between
    # 3 and 2.85.
    ##
    def test_band2_success
      gases = []

      Sensly::SensorMQ2(BAND2_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 2
    end

    ##
    # Test for the correct identification of carbon monoxide, methane and alcohol with an RSR0 ratio
    # between 2.85 and 2.1.
    ##
    def test_band3_success
      gases = []

      Sensly::SensorMQ2(BAND3_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 3
    end

    ##
    # Test for the correct identification of carbon monoxide, methane, alcohol and hydrogen with an
    # RSR0 ratio between 2.1 and 1.8.
    ##
    def test_band4_success
      gases = []

      Sensly::SensorMQ2(BAND4_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 4
    end

    ##
    # Test for the correct identification of carbon monoxide, methane, alcohol, hydrogen, propane
    # and liquid petroleum gas with an RSR0 ratio between 1.8 and 1.6.
    ##
    def test_band5_success
      gases = []

      Sensly::SensorMQ2(BAND5_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 6
    end

    ##
    # Test for the correct identification of methane, alcohol and hydrogen, propane and liquid
    # petroleum gas with an RSR0 ratio between 1.6 and 0.69.
    ##
    def test_band6_success
      gases = []

      Sensly::SensorMQ2(BAND6_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 5
    end

    ##
    # Test for the correct identification of hydrogen, propane and liquid petroleum gas with an RSR0
    # ratio between 0.69 and 0.335.
    ##
    def test_band7_success
      gases = []

      Sensly::SensorMQ2(BAND7_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 3
    end

    ##
    # Test for the correct identification of propane and liquid petroleum gas with an RSR0 ratio
    # between 0.335 and 0.26.
    ##
    def test_band8_success
      gases = []

      Sensly::SensorMQ2(BAND8_UPPER).gases do |gas|
        gases.push gas
      end

      assert gases.length, 2
    end

    ##
    # Test for no gases detected for an RSR0 ration above 5.2.
    ##
    def test_above_upper_limit
      gases = []

      Sensly::SensorMQ2(0).gases do |gas|
        gases.push gas
      end

      assert_equal gases.length, 0
    end

    ##
    # Test for no gases detected for an RSR0 ration below 0.26
    ##
    def test_below_lower_limit
      gases = []

      Sensly::SensorMQ2(4095).gases do |gas|
        gases.push gas
      end

      assert gases.length, 0
    end
  end

