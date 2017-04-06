require 'sensly/sensors/mq_sensor'

module Sensly
  ##
  #
  ##
  class MQ135Sensor < MQSensor
    ##
    #
    ##
    def initialize(adc_value, r0, temperature, humidity)
      super adc_value, r0, temperature, humidity

      @rs_ro_ratio = correct_rs_ro_ratio
    end

    ##
    # Coefficient of <something> at 33% and 85% relative humidity
    # in the format a, b, c, d which relates to ax**3 + bx**2 + cx + d
    ##
    COEFF_33RH = [-0.00000042, 0.00036988, -0.02723828, 1.40020563].freeze
    COEFF_85RH = [-0.0000002, 0.00028254, -0.02388492, 1.27309524].freeze

    ##
    #
    ##
    CONFIG_CO = {
      min: 1.44,
      max: 2.85,
      gradient: -4.2720,
      intercept: 2.9347
    }.freeze
    CONFIG_NH3 = {
      min: 0.585,
      max: 2.59,
      gradient: -2.4562,
      intercept: 2.0125
    }.freeze
    CONFIG_CO2 = {
      min: 0.8,
      max: 2.35,
      gradient: -2.7979,
      intercept: 2.0425
    }.freeze
    CONFIG_ETHANOL = {
      min: 0.585,
      max: 1.91,
      gradient: -3.1616,
      intercept: 1.8939
    }.freeze
    CONFIG_METHYL = {
      min: 0.585,
      max: 1.61,
      gradient: -3.2581,
      intercept: 1.6759
    }.freeze
    CONFIG_ACETONE = {
      min: 0.585,
      max: 1.51,
      gradient: -3.1878,
      intercept: 1.5770
    }.freeze

    ##
    #
    ##
    GAS_CONFIG = {
      GAS_CO => CONFIG_CO,
      GAS_NH3 => CONFIG_NH3,
      GAS_CO2 => CONFIG_CO2,
      GAS_ETHANOL => CONFIG_ETHANOL,
      GAS_METHYL => CONFIG_METHYL,
      GAS_ACETONE => CONFIG_ACETONE
    }.freeze

    ##
    #
    ##
    def correct_rs_ro_ratio
      at_thirty_three_rh = amb_temp_at_rel_humidity COEFF_33RH
      at_eighty_five_rh = amb_temp_at_rel_humidity COEFF_85RH
      at_sixty_five_rh = (
        (
          ((65.0 - 33.0) / (85.0 - 65.0)) *
          (at_eighty_five_rh - at_thirty_three_rh)
        ) + at_thirty_three_rh
      ) * 1.102

      if @humidity < 65.0
        rs_ro_at_amb_rh = (
          (
            (@humidity - 33.0) / (65.0 - 33.0) *
            (at_sixty_five_rh - at_thirty_three_rh)
          ) + at_thirty_three_rh)
      else
        rs_ro_at_amb_rh = (
          (
            (@humidity - 65.0) / (85.0 - 65.0) *
            (at_eighty_five_rh - at_sixty_five_rh)
          ) + at_sixty_five_rh)
      end

      # at 20C and 60rh
      ref_rs_ro = 1.0

      rs_ro_corr_pct = 1.0 + (ref_rs_ro - rs_ro_at_amb_rh) / ref_rs_ro
      return rs_ro_corr_pct * rs_ro_ratio
    end
  end
end
