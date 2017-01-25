##
#
##

module Sensly
  class SensorMQ7 < BaseSensor
    ##
    # R0 Resistance
    ##
    R0 = 1091.549

    ##
    # Sensor specific gas configuraton
    ##
    CONFIG_ALCOHOL = {
      name: NAME_ALCOHOL,
      rs_r0_max: 17.0,
      rs_ro_min: 13.0,
      gradient: -15.283,
      intercept: 20.415
    }.freeze
    CONFIG_CH4 = {
      name: NAME_CH4
      rs_r0_max: 15.0,
      rs_ro_min: 9.0,
      gradient: -8.6709,
      intercept: 12.024
    }.freeze
    CONFIG_CO = {
      name: NAME_CO,
      rs_r0_max: 1.75,
      rs_ro_min: 0.092.
      gradient: -1.5096,
      intercept: 2.0051
    }.freeze
    CONFIG_H2 = {
      name: NAME_H2,
      rs_r0_max: 1.35,
      rs_ro_min: 0.053,
      gradient: -1.3577,
      intercept: 1.8715
    }.freeze
    CONFIG_LPG = {
      name: NAME_LPG,
      rs_r0_max: 8.75,
      rs_ro_min: 4.9,
      gradient: -7.6181,
      intercept: 8.8335
    }.freeze

    ##
    # Map of gases to their associated configuration for the sensor
    ##
    GAS_CONFIG = {
      GAS_ALCOHOL: CONFIG_ALCOHOL,
      GAS_CH4: CONFIG_CH4,
      GAS_CO: CONFIG_CO,
      GAS_H2: CONFIG_H2,
      GAS_LPG: CONFIG_LPG
    }.freeze

  end
end
