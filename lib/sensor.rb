##
#
##
module Sensors
  ##
  #
  ##
  def convert_adc_to_gases(sensor, adc_value)
    # see config/initializers/constants.rb for sensor type constants
    # check which sensor type it is
    # redirect to correct function
    # or raise an error if it's not found
  end

  private

  ##
  #
  ##
  def convert_mq2_adc(adc_value)
  end

  ##
  #
  ##
  def convert_mq7_adc(adc_value)
  end

  ##
  #
  ##
  def convert_mq135_adc(adc_value)
  end
end
