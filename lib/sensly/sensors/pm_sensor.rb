require 'sensly/sensors/base_sensor'

module Sensly
  ##
  #
  ##
  class PMSensor < BaseSensor
    ##
    #
    ##
    NO_DUST_VOLTAGE = 500.0

    ##
    #
    ##
    COV_RATIO = 0.2

    ##
    #
    ##
    def initialize(adc_value)
      super adc_value
    end

    ##
    # Calculate the particulate matter density.
    ##
    def pm_density
      pm_volt = pm_voltage
      pm_density = 0.0

      if pm_volt >= NO_DUST_VOLTAGE
        pm_density = (pm_volt - NO_DUST_VOLTAGE) * COV_RATIO
      end

      return pm_density
    end

    private

    ##
    # Convert the raw ADC data to a voltage.
    ##
    def pm_voltage
      return (3300.0 / MAX_ADC) * @adc_value * 11.0
    end
  end
end
