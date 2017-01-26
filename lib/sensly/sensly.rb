require 'sensly/exceptions'
require 'sensly/sensors/sensor_mq2'
require 'sensly/sensors/sensor_mq7'
require 'sensly/sensors/sensor_mq135'

##
#
##
module Sensly
  ##
  #
  ##
  TYPE_MQ2 = 1
  TYPE_MQ7 = 2
  TYPE_MQ135 = 3

  ##
  #
  ##
  TYPES = {
    TYPE_MQ2: SensorMQ2,
    TYPE_MQ7: SensorMQ7,
    TYPE_MQ135: SensorMQ135
  }.freeze

  def sensor(type, adc_value)
    case type
    when TYPE_MQ2
      return SensorMQ2(adc_value)

    when TYPE_MQ7
      return SensorMQ7(adc_value)

    when TYPE_MQ135
      return SensorMQ135(adc_value)

    else
      raise UnrecognisedSensorTypeError, 'Unrecognised sensor type'
    end
  end
end
