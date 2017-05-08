require 'sensly/sensors/mq_sensor'

module Sensly
  ##
  # MQ7 sensor class.
  ##
  class MQ7Sensor < MQSensor
    ##
    # Constructor for the sensor.
    ##
    def initialize(adc_value, r0, temperature, humidity)
      super adc_value, r0, temperature, humidity

      @rs_ro_ratio = correct_rs_ro_ratio
    end

    ##
    # Coefficient of <something> at 33% and 85% relative humidity
    # in the format a, b, c, d which relates to ax**3 + bx**2 + cx + d
    ##
    COEFF_33RH = [-0.00001017, 0.00076638, -0.01894577, 1.1637335].freeze
    COEFF_85RH = [-0.00000481, 0.0003916, -0.01267189, 0.99930744].freeze

    ##
    # Configuration for each gas detected by the sensor.
    ##
    CONFIG_ALCOHOL = {
      min: 13.0,
      max: 17.0,
      gradient: -15.283,
      intercept: 20.415
    }.freeze
    CONFIG_CH4 = {
      min: 9.0,
      max: 15.0,
      gradient: -8.6709,
      intercept: 12.024
    }.freeze
    CONFIG_LPG = {
      min: 4.9,
      max: 8.75,
      gradient: -7.6181,
      intercept: 8.8335
    }.freeze
    CONFIG_CO = {
      min: 0.092,
      max: 1.75,
      gradient: -1.5096,
      intercept: 2.0051
    }.freeze
    CONFIG_H2 = {
      min: 0.053,
      max: 1.35,
      gradient: -1.3577,
      intercept: 1.8715
    }.freeze

    ##
    # Maps gas ids to their configurations.
    ##
    GAS_CONFIG = {
      GAS_ALCOHOL => CONFIG_ALCOHOL,
      GAS_CH4 => CONFIG_CH4,
      GAS_LPG => CONFIG_LPG,
      GAS_CO => CONFIG_CO,
      GAS_H2 => CONFIG_H2
    }.freeze

    ##
    # Correct the RsR0 value for temperature and humidity.
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
