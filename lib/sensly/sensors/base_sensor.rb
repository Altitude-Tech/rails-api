module Sensly
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
    NAME_NH4 = 'Ammonia'.freeze

    ##
    #
    ##
    def initialize(adc_value)
      unless adc_value.between? 0, MAX_ADC_VALUE
        # TODO: throw error
      end

      calc_rs_r0 adc_value, R0
    end

    ##
    #
    ##
    def gases
      filter_gases

      for gas in convert_to_gases
        yield gas
      end
    end

    protected

    ##
    #
    ##
    def calc_rs_ro_ratio(adc_value, r0)
      rs = (MAX_ADC_VALUE / Float(adc_value)) - 1.0) * RLOAD
      @rs_r0_ratio = rs / r0
    end

    ##
    #
    ##
    def filter_gases
      @gases = []

      GAS_CONFIG.each do |k, v|
        if @rs_r0_ratio.between? v[:rs_ro_min], v[:rs_ro_max]
          @gases.push k
        end
      end
    end

    ##
    #
    ##
    def convert_to_gases
      ret = []

      for gas in @gases
        cfg = GAS_CONFIG[gas]
        ppm = 10**((cfg[:gradient] * Math.log10(@rs_r0_ratio)) + cfg[:intercept])

        data = {}

        data[:ppm] = ppm
        data[:id] = gas
        data[:name] = cfg[:name]

        ret.push(data)
      end

      return ret
    end
  end
end
