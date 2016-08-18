##
# Methods for helping calculate concentration
##
module Concentration
  ##
  # Gravitational acceleration in metres per second per second
  ##
  GRAVITATIONAL_ACCELERATION = 9.80665

  ##
  # The universal gas constant in pascal cubic metres per moles kelvin
  # ((Pa m^3) / (mol K))
  ##
  UNIVERSAL_GAS_CONSTANT = 8.31445

  ##
  # Molar mass of air in kilograms per mole
  ##
  AIR_MOLAR_MASS = 0.0289644

  ##
  # Molar masses of supported gases in grams per mole
  ##
  CO_MOLAR_MASS = 28.01
  NO2_MOLAR_MASS = 46.0055
  # All of the below are composites
  # So molar mass could vary depending on environment
  #
  # @todo get mass for these
  ALCOHOLS_MOLAR_MASS = 0
  SMOKE_MOLAR_MASS = 0
  TOXIC_GASES_MOLAR_MASS = 0
  PM10_MOLAR_MASS = 0
  PM25_MOLAR_MASS = 0

  ##
  # Link supported gases to their respective mass
  ##
  GASES = {
    GAS_CARBON_MONOXIDE => CO_MOLAR_MASS,
    GAS_NITROGEN_DIOXIDE => NO2_MOLAR_MASS,
    GAS_ALCOHOLS => ALCOHOLS_MOLAR_MASS,
    GAS_SMOKE => SMOKE_MOLAR_MASS,
    GAS_TOXIC_GASES => TOXIC_GASES_MOLAR_MASS,
    GAS_PM10 => PM10_MOLAR_MASS,
    GAS_PM25 => PM25_MOLAR_MASS
  }.freeze

  ##
  # Converts a temperature in centigrade to kelvin.
  #
  # Params:
  #   temperature (Number): Temperature in centigrade.
  #
  # Returns:
  #   (Number): Temperature in kelvin.
  ##
  def self.centigrade_to_kelvin(temperature)
    temperature + 273.15
  end

  ##
  # Calculates the density of a gas.
  #
  # Params:
  #   gas (String): The id of the gas as defined in
  #     config/initializers/constants.rb
  #   temperature (Number): The temperature in kelvin.
  #   pressure (Number): The air pressure in pascals.
  #
  # Returns:
  #   (Number): The density in grams per metres cubed.
  ##
  def self.calc_density(gas, temperature, pressure)
    molar_mass = GASES[gas]
    (molar_mass * pressure) / (UNIVERSAL_GAS_CONSTANT * temperature)
  end

  ##
  # Convert a concentration in parts per million to micrograms per cubic metre.
  #
  # Params:
  #   concentration (Number): Concentration in parts per million.
  #   gas (String): The id of the gas as defined in
  #     config/initializers/constants.rb
  #   temperature (Number): The temperature in kelvin.
  #   pressure (Number): The air pressure in pascals.
  #
  # Returns:
  #   (Number): Concentration in micrograms per cubic metre.
  ##
  def self.ppm_to_ugm3(concentration, gas, temperature, pressure)
    density = calc_density(gas, temperature, pressure)
    concentration * density
  end

  ##
  # Convert a concentration in micrograms per cubic metre to parts per million.
  #
  # Params:
  #   concentration (Number): Concentration in micrograms per cubic metre.
  #   gas (String): The id of the gas as defined in
  #     config/initializers/constants.rb
  #   temperature (Number): The temperature in kelvin.
  #   pressure (Number): The air pressure in pascals.
  #
  # Returns:
  #   (Number): Concentration in parts per million.
  ##
  def self.ugm3_to_ppm(concentration, gas, temperature, pressure)
    density = calc_density(gas, temperature, pressure)
    concentration / density
  end
end
