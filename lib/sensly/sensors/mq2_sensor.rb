require 'sensly/sensors/mq_sensor'

module Sensly
  ##
  #
  ##
  class MQ2Sensor < MQSensor
    ##
    #
    ##
    def initialize(adc_value, r0, temperature, humidity)
      super adc_value, r0, temperature, humidity

      @rs_ro_ratio = correct_rs_ro_ratio
    end

    ##
    # Coefficient of <something> at 30%, 60% and 85% relative humidity
    # in the format a, b, c, d which relates to ax**3 + bx**2 + cx + d
    ##
    COEFF_30RH = [-0.00000072, 0.00006753, -0.01530561, 1.5594955].freeze
    COEFF_60RH = [-0.00000012, 0.00003077, -0.01287521, 1.32473027].freeze
    COEFF_85RH = [-0.00000033, 0.00004116, -0.01135847, 1.14576424].freeze

    ##
    #
    ##
    CONFIG_ALCOHOL = {
      min: 0.69,
      max: 2.85,
      gradient: -2.7171,
      intercept: 3.5912
    }.freeze
    CONFIG_CH4 = {
      min: 0.69,
      max: 3,
      gradient: -2.6817,
      intercept: 3.623
    }.freeze
    CONFIG_CO = {
      min: 1.6,
      max: 5.2,
      gradient: -3.2141,
      intercept: 4.624
    }.freeze
    CONFIG_H2 = {
      min: 0.335,
      max: 2.1,
      gradient: -2.0588,
      intercept: 3.017
    }.freeze
    CONFIG_LPG = {
      min: 0.26,
      max: 1.8,
      gradient: -2.0626,
      intercept: 2.808
    }.freeze
    CONFIG_PROPANE = {
      min: 0.26,
      max: 1.8,
      gradient: -2.0813,
      intercept: 2.8436
    }.freeze

    ##
    #
    ##
    GAS_CONFIG = {
      GAS_ALCOHOL => CONFIG_ALCOHOL,
      GAS_CH4 => CONFIG_CH4,
      GAS_CO => CONFIG_CO,
      GAS_H2 => CONFIG_H2,
      GAS_LPG => CONFIG_LPG,
      GAS_PROPANE => CONFIG_PROPANE
    }.freeze

    ##
    #
    ##
    def correct_rs_ro_ratio
      at_thirty_rh = amb_temp_at_rel_humidity COEFF_30RH
      at_sixty_rh = amb_temp_at_rel_humidity COEFF_60RH
      at_eighty_five_rh = amb_temp_at_rel_humidity COEFF_85RH

      if @humidity < 60.0
        rs_ro_at_amb_rh = (
          (
            (@humidity - 30.0) / (60.0 - 30.0) *
            (at_sixty_rh - at_thirty_rh)
          ) + at_thirty_rh)
      else
        rs_ro_at_amb_rh = (
          (
            (@humidity - 60.0) / (85.0 - 60.0) *
            (at_eighty_five_rh - at_sixty_rh)
          ) + at_sixty_rh)
      end

      # at 20C and 60rh
      ref_rs_ro = 1.0

      rs_ro_corr_pct = 1.0 + (ref_rs_ro - rs_ro_at_amb_rh) / ref_rs_ro
      return rs_ro_corr_pct * rs_ro_ratio
    end
  end
end
