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

  ##
  # Map of gas integers to their names as a string.
  ##
  GAS_NAMES = {
    GAS_ACETONE: 'Acetone',
    GAS_ALCOHOL: 'Alcohol',
    GAS_CH4: 'Methane',
    GAS_CO: 'Carbon Monoxide',
    GAS_CO2: 'Carbon Dioxide',
    GAS_ETHANOL: 'Ethanol',
    GAS_H2: 'Hydrogen',
    GAS_LPG: 'Liquid Petroleum Gas',
    GAS_METHYL: 'Methyl',
    GAS_NH3: 'Ammonia',
    GAS_PROPANE: 'Propane'
  }.freeze

  ##
  # Convert an integer representation of a gas into a string representing it's name.
  ##
  def gas_name(gas)
    return GAS_NAMES[gas]
  end
end
