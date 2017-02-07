##
#
##

require 'sensly/sensors/base_sensor'

module Sensly
  class SensorMQ2 < BaseSensor
    ##
    # R0 Resistance
    ##
    R0 = 3896.997

    ##
    # Sensor specific gas configuraton
    ##
    CONFIG_ALCOHOL = {
      name: NAME_ALCOHOL,
      rs_ro_max: 2.85,
      rs_ro_min: 0.69,
      gradient: 2.7171,
      intercept: 3.5912
    }.freeze
    CONFIG_CH4 = {
      name: NAME_CH4,
      rs_ro_max: 3.0,
      rs_ro_min: 0.69,
      gradient: -2.6817,
      intercept: 3.623
    }.freeze
    CONFIG_CO = {
      name: NAME_CO,
      rs_ro_max: 5.2,
      rs_ro_min: 1.6,
      gradient: -3.2141,
      intercept: 4.624
    }.freeze
    CONFIG_H2 = {
      name: NAME_H2,
      rs_ro_max: 2.1,
      rs_ro_min: 0.335,
      gradient: -2.0588,
      intercept: 3.017
    }.freeze
    CONFIG_LPG = {
      name: NAME_LPG,
      rs_ro_max: 1.8,
      rs_ro_min: 0.26,
      gradient: -2.0626,
      intercept: 2.808
    }.freeze
    CONFIG_PROPANE = {
      name: NAME_PROPANE,
      rs_ro_max: 1.8,
      rs_ro_min: 0.26,
      gradient: -2.0813,
      intercept: 2.8436
    }.freeze

    ##
    # Map of gases to their associated configuration for the sensor
    ##
    GAS_CONFIG = {
      GAS_ALCOHOL: CONFIG_ALCOHOL,
      GAS_CH4: CONFIG_CH4,
      GAS_CO: CONFIG_CO,
      GAS_H2: CONFIG_H2,
      GAS_LPG: CONFIG_LPG,
      GAS_PROPANE: CONFIG_PROPANE
    }.freeze
  end
end
