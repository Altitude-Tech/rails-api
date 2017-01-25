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
    unless TYPES.include? type
      # throw error
    end

    return TYPES[types](adc_value)
  end
end
