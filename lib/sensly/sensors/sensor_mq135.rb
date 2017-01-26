##
#
##

require 'sensly/sensors/base_sensor'

module Sensly
  class SensorMQ135 < BaseSensor
    ##
    # R0 Resistance
    ##
    R0 = 10_804.861

    ##
    # Sensor specific gas configuraton
    ##
    CONFIG_ACETONE = {
      name: NAME_ACETONE,
      rs_r0_max: 1.51,
      rs_ro_min: 0.585,
      gradient: -3.1878,
      intercept: 1.577
    }.freeze
    CONFIG_CO = {
      name: NAME_CO,
      rs_r0_max: 2.85,
      rs_ro_min: 1.44,
      gradient: -4.272,
      intercept: 2.9347
    }.freeze
    CONFIG_CO2 = {
      name: NAME_CO2,
      rs_r0_max: 2.35,
      rs_ro_min: 0.8,
      gradient: -2.7979,
      intercept: 2.0425
    }.freeze
    CONFIG_ETHANOL = {
      name: NAME_ETHANOL,
      rs_r0_max: 1.91,
      rs_ro_min: 0.585,
      gradient: -3.1616,
      intercept: 1.8939
    }.freeze
    CONFIG_METHYL = {
      name: NAME_METHYL,
      rs_r0_max: 1.61,
      rs_ro_min: 0.585,
      gradient: -3.2581,
      intercept: 1.6759
    }.freeze
    CONFIG_NH3 = {
      name: NAME_NH3,
      rs_r0_max: 2.59,
      rs_ro_min: 0.585,
      gradient: -2.4562,
      intercept: 2.0125
    }.freeze

    ##
    # Map of gases to their associated configuration for the sensor
    ##
    GAS_CONFIG = {
      GAS_ACETONE: CONFIG_ACETONE,
      GAS_CO: CONFIG_CO,
      GAS_CO2: CONFIG_CO2,
      GAS_ETHANOL: CONFIG_ETHANOL,
      GAS_METHYL: CONFIG_METHYL,
      GAS_NH3: CONFIG_NH3
    }.freeze
  end
end
