require 'sensly/sensors/base_sensor'

module Sensly
  ##
  # Sensor for detecting particulate matter larger than 10 microns (um).
  #
  # TODO: Give this a better name closer to what the sensor is called.
  ##
  class PMSensor < BaseSensor
    ##
    # Minimum value for the voltage.
    # Values below this will cause the density returned to be 0.
    ##
    NO_DUST_VOLTAGE = 500.0

    ##
    # Conversion ratio to convert voltage to density.
    ##
    COV_RATIO = 0.2

    ##
    # Constructor for the sensor.
    ##
    def initialize(adc_value)
      super adc_value
    end

    ##
    # Calculate the particulate matter density in ug/m3.
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
    # Yields the name and ppm of the particulate matter.
    #
    # This exists to allow all sensors to respond to this method.
    # In reality, unlike the MQ sensors, this will only ever return one set of values.
    ##
    def gases
      data = {}

      data[:name] = NAME_PM
      data[:conc_ugm3] = pm_density

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
