##
# Methods for helping calculate concentration
#
# For pressure calculation help, see <http://enwp.org/Barometric_formula>
# For concentration conversion help, see <http://antoine.frostburg.edu/chem/senese/101/solutions/faq/converting-ppm-to-micrograms-per-cubic-meter.shtml>
##

module Concentration
  ##
  # Altitude layers in metres
  #
  # Only altitudes between 0-19999m are supported
  # but for completeness other known layers have been left in
  ##
  ALTITUDE_LAYERS = [0, 11000, 20000, 32000, 47000, 51000, 71000]

  ##
  # Static pressure for given altitude layers in pascals
  ##
  STATIC_PRESSURES = [101325.00, 22632.10, 5474.89, 868.02, 66.94, 3.96]

  ##
  # Standard temperature for given altitude layers in kelvin
  ##
  STANDARD_TEMPERATURES = [288.15, 216.65, 216.65, 228.65, 270.65, 270.65, 214.65]

  ##
  # Temperature lapse rates for altitude layers in kelvin per metre
  ##
  TEMPERATURE_LAPSE_RATES = [-0.0065, 0.0, 0.001, 0.0028, 0.0, -0.0028, -0.002]

  ##
  # Gravitational acceleration in metres per second per second
  ##
  GRAVITATIONAL_ACCELERATION = 9.80665

  ##
  # The universal gas constant in pascal cubic metres per moles kelvin ((Pa m^3) / (mol K))
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
  GASES = {}
  # see config/initializers/gases.rb for available gases
  GASES[GAS_CARBON_MONOXIDE] = CO_MOLAR_MASS
  GASES[GAS_NITROGEN_DIOXIDE] = NO2_MOLAR_MASS
  GASES[GAS_ALCOHOLS] = ALCOHOLS_MOLAR_MASS
  GASES[GAS_SMOKE] = SMOKE_MOLAR_MASS
  GASES[GAS_TOXIC_GASES] = TOXIC_GASES_MOLAR_MASS
  GASES[GAS_PM10] = PM10_MOLAR_MASS
  GASES[GAS_PM25] = PM25_MOLAR_MASS

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
  # Calculates air pressure.
  #
  # Params:
  #   altitude (Number): The altitude in metres.
  #
  # Returns:
  #   (Number): The pressure in pascals.
  #
  # Raises:
  #   ArgumentError: altitude cannot be negative.
  #   ArgumentError: altitude must be less than 20000.
  ##
  def self.calc_pressure(altitude)
    if altitude < 0
      raise ArgumentError, 'altitude cannot be negative.'
    end

    if altitude >= 20000
      raise ArgumentError, 'altitude must be less than 20000.'
    end

    layer, index = get_altitude_layer(altitude)

    sp = STATIC_PRESSURES[index]
    st = STANDARD_TEMPERATURES[index]
    tlr = TEMPERATURE_LAPSE_RATES[index]

    if tlr === 0
      calc_pressure_zero(sp, st, tlr, altitude, layer)
    else
      calc_pressure_non_zero(sp, st, tlr, altitude, layer)
    end
  end

  ##
  # Calculates the density of a gas.
  #
  # Params:
  #   gas (String): The name of the gas. Permitted values are as follows and case insensitive:
  #     - carbon monoxide, co
  #     - nitrogen dioxide, no2
  #   temperature (Number): The temperature in kelvin.
  #   altitude (Number): The distance above sea level in metres.
  #
  # Returns:
  #   (Number): The density in grams per metres cubed.
  ##
  def self.calc_density(gas, temperature, altitude)
    molar_mass = GASES[gas]
    pressure = calc_pressure(altitude)

    # <http://antoine.frostburg.edu/chem/senese/101/solutions/faq/converting-ppm-to-micrograms-per-cubic-meter.shtml>
    (molar_mass * pressure) / (UNIVERSAL_GAS_CONSTANT * temperature)
  end

  ##
  # Convert a concentration in parts per million to micrograms per cubic metre.
  #
  # Params:
  #   concentration (Number): Concentration in parts per million.
  #   gas (String): The name of the gas. Permitted values are as follows and case insensitive:
  #     - carbon monoxide, co
  #     - nitrogen dioxide, no2
  #   temperature (Number): The temperature in kelvin.
  #   altitude (Number): The distance above sea level in metres.
  #
  # Returns:
  #   (Number): Concentration in micrograms per cubic metre.
  ##
  def self.ppm_to_ugm3(concentration, gas, temperature, altitude)
    density = calc_density(gas, temperature, altitude)
    concentration * density
  end

  ##
  # Convert a concentration in micrograms per cubic metre to parts per million.
  #
  # Params:
  #   concentration (Number): Concentration in micrograms per cubic metre.
  #   gas (String): The name of the gas. Permitted values are as follows and case insensitive:
  #     - carbon monoxide, co
  #     - nitrogen dioxide, no2
  #   temperature (Number): The temperature in kelvin.
  #   altitude (Number): The distance above sea level in metres.
  #
  # Returns:
  #   (Number): Concentration in parts per million.
  ##
  def self.ugm3_to_ppm(concentration, gas, temperature, altitude)
    density = calc_density(gas, temperature, altitude)
    concentration / density
  end

  private
    ##
    # Get the altitude at the base of the layer for a given altitude.
    #
    # Params:
    #   altitude (Number): The altitude in metres.
    #
    # Returns:
    #   (Number): The altitude at the base of the layer.
    #   (Number): The index of the layer.
    ##
    def self.get_altitude_layer(altitude)
      last = 0
      last_index = 0

      ALTITUDE_LAYERS.each_with_index do |layer, index|
        if altitude <= layer
          break
        end

        last = layer
        last_index = index
      end

      # rubocop:disable RedundantReturn
      return last, last_index
      # rubocop:enable RedundantReturn
    end

    ##
    # Calculates air pressure when the temperature lapse rate is 0.
    #
    # Params:
    #   sp (Number): The static pressure in pascals.
    #   st (Number): The standard temperature in kelvin.
    #   tlr (Number): The temperature lapse rate in kelvin per metre.
    #   h (Number): The current altitude in metres.
    #   hb (Number): The altitude at the bottom of the layer in metres.
    #
    # Returns:
    #   (Number): The pressure in pascals.
    ##
    def self.calc_pressure_zero(sp, st, tlr, h, hb)
      g = GRAVITATIONAL_ACCELERATION
      m = AIR_MOLAR_MASS
      r = UNIVERSAL_GAS_CONSTANT

      sp * Math.exp((-g * m * (h - hb)) / (r * st))
    end

    ##
    # Calculates air pressure when the temperature lapse rate is not 0.
    #
    # Params:
    #   sp (Number): The static pressure in pascals.
    #   st (Number): The standard temperature in kelvin.
    #   tlr (Number): The temperature lapse rate in kelvin per metre.
    #   h (Number): The current altitude in metres.
    #   hb (Number): The altitude at the bottom of the layer in metres.
    #
    # Returns:
    #   (Number): The pressure in pascals.
    ##
    def self.calc_pressure_non_zero(sp, st, tlr, h, hb)
      g = GRAVITATIONAL_ACCELERATION
      m = AIR_MOLAR_MASS
      r = UNIVERSAL_GAS_CONSTANT

      sp * ((st / (st + (tlr * (h - hb))))**((g * m) / (r * tlr)))
    end
end
