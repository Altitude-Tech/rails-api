require 'sensly/exceptions'

module Sensly
  ##
  # Gases detected by the sensors
  ##
  GAS_ACETONE = 1
  GAS_ALCOHOL = 2
  GAS_CH4 = 3
  GAS_CO = 4
  GAS_CO2 = 5
  GAS_ETHANOL = 6
  GAS_H2 = 7
  GAS_LPG = 8
  GAS_PROPANE = 9
  GAS_METHYL = 10
  GAS_NH3 = 11

  ##
  # Names of the gases
  ##
  NAME_ACETONE = 'Acetone'.freeze
  NAME_ALCOHOL = 'Alcohol'.freeze
  NAME_CH4 = 'Methane'.freeze
  NAME_CO = 'Carbon Monoxide'.freeze
  NAME_CO2 = 'Carbon Dioxide'.freeze
  NAME_ETHANOL = 'Ethanol'.freeze
  NAME_H2 = 'Hydrogen'.freeze
  NAME_LPG = 'Liquid Petroleum Gas'.freeze
  NAME_PROPANE = 'Propane'.freeze
  NAME_METHYL = 'Methyl'.freeze
  NAME_NH3 = 'Ammonia'.freeze

  ##
  # Abstract implementation of a sensor.
  #
  # Contains all the logic required for converting a raw ADC value to gas concentration in PPM.
  #
  # Child classes should implement a GAS_CONFIG property containing a hash which maps a specific gas
  # that the sensor can detect to sensor specific configuration values for each gas.
  ##
  class BaseSensor
    ##
    # Maximum value of the ADC (2**12 - 1)
    ##
    MAX_ADC_VALUE = 4095.0

    ##
    # TODO: Document this
    ##
    RLOAD = 10_000.0

    ##
    #
    ##
    def initialize(adc_value)
      unless adc_value.between? 0, MAX_ADC_VALUE
        msg = "ADC value must be between 0 and #{MAX_ADC_VALUE}, received #{adc_value}"
        raise ADCValueOutOfRangeError, msg
      end

      # puts "adc_value: #{adc_value}"
      calc_rs_ro_ratio adc_value, self.class::R0
      # puts "rs_ro_ratio: #{@rs_ro_ratio}"
    end

    ##
    #
    ##
    def gases
      filter_gases

      convert_to_gases.each do |gas|
        yield gas
      end
    end

    ##
    #
    ##
    def rs_ro
      return @rs_ro_ratio
    end

    protected

    ##
    #
    ##
    def calc_rs_ro_ratio(adc_value, ro)
      rs = ((MAX_ADC_VALUE / Float(adc_value)) - 1.0) * RLOAD
      # puts "rs: #{rs}, ro: #{ro}"
      @rs_ro_ratio = rs / ro
    end

    ##
    #
    ##
    def filter_gases
      @gases = []

      self.class::GAS_CONFIG.each do |k, v|
        if @rs_ro_ratio.between? v[:rs_ro_min], v[:rs_ro_max]
          @gases.push k
        end
      end
    end

    ##
    #
    ##
    def convert_to_gases
      ret = []

      @gases.each do |gas|
        cfg = self.class::GAS_CONFIG[gas]
        ppm = 10**((cfg[:gradient] * Math.log10(@rs_ro_ratio)) + cfg[:intercept])

        data = {}

        data[:ppm] = ppm
        data[:id] = gas
        data[:name] = cfg[:name]
        data[:rs_ro] = @rs_ro_ratio

        ret.push(data)
      end

      return ret
    end
  end
end
