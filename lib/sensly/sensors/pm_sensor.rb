require 'sensly/sensors/base_sensor'

module Sensly
  ##
  # Sensor for detecting particulate matter.
  #
  # TODO: what size particles does this detect?
  # TODO: Give this a better name closer to what the sensor is called.
  ##
  class PMSensor < BaseSensor
    ##
    # TODO: document this
    ##
    NO_DUST_VOLTAGE = 500.0

    ##
    # TODO: Document this
    ##
    COV_RATIO = 0.2

    def initialize(adc_value)
      super adc_value
    end

    ##
    # Calculate the particulate matter density.
    #
    # TODO: Return data in what units?
    ##
    def pm_density
      pm_volt = pm_voltage
      pm_density = 0.0

      if pm_volt >= NO_DUST_VOLTAGE
        pm_density = (pm_volt - NO_DUST_VOLTAGE) * COV_RATIO
      end

      return pm_density
    end

    ##
    #
    ##
    def gases
      data = {}

      data[:name] = NAME_PM
      data[:ppm] = pm_density

      yield data
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
