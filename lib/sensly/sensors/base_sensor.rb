require 'sensly/exceptions'
require 'sensly/sensly'

module Sensly
  class BaseSensor
    ##
    # Max value the ADC can produce.
    ##
    MAX_ADC = 4095.0

    ##
    #
    ##
    def initialize(adc_value)
      unless adc_value.between? 0, MAX_ADC
        msg = "ADC value must be between 0 and #{MAX_ADC}, received #{adc_value}"
        raise ADCValueOutOfRangeError, msg
      end

      @adc_value = float adc_value
    end
  end
end
