##
# Module for converting ADC values produced by various sensors.
##
module Sensly
  ##
  # Gases the sensors can detect.
  ##
  GAS_ACETONE = 1
  GAS_ALCOHOL = 2
  GAS_CH4 = 3
  GAS_CO = 4
  GAS_CO2 = 5
  GAS_ETHANOL = 6
  GAS_H2 = 7
  GAS_LPG = 8
  GAS_METHYL = 9
  GAS_NH3 = 10
  GAS_PROPANE = 11
  GAS_PM = 12

  ##
  # Name of the gases.
  ##
  NAME_ACETONE = 'Acetone'.freeze
  NAME_ALCOHOL = 'Alcohol'.freeze
  NAME_CH4 = 'Methane'.freeze
  NAME_CO = 'Carbon Monoxide'.freeze
  NAME_CO2 = 'Carbon Dioxide'.freeze
  NAME_ETHANOL = 'Ethanol'.freeze
  NAME_H2 = 'Hydrogen'.freeze
  NAME_LPG = 'Liquid Petroleum Gas'.freeze
  NAME_METHYL = 'Methyl'.freeze
  NAME_NH3 = 'Ammonia'.freeze
  NAME_PROPANE = 'Propane'.freeze
  NAME_PM = 'Particulate Matter'.freeze

  ##
  # Map of gas integers to their names as a string.
  ##
  GAS_NAMES = {
    GAS_ACETONE => NAME_ACETONE,
    GAS_ALCOHOL => NAME_ALCOHOL,
    GAS_CH4 => NAME_CH4,
    GAS_CO => NAME_CO,
    GAS_CO2 => NAME_CO2,
    GAS_ETHANOL => NAME_ETHANOL,
    GAS_H2 => NAME_H2,
    GAS_LPG => NAME_LPG,
    GAS_METHYL => NAME_METHYL,
    GAS_NH3 => NAME_NH3,
    GAS_PROPANE => NAME_PROPANE,
    GAS_PM => NAME_PM
  }.freeze

  ##
  # Convert an integer representation of a gas into a string representing its name.
  ##
  def self.gas_name(gas)
    return GAS_NAMES[gas]
  end
end
