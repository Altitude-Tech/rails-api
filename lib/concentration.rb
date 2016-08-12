##
# Methods for helping calculate concentration
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
	# Aliases for supported gases
	##
	GASES = {
		# carbon monoxide
		'co'				=> CO_MOLAR_MASS,
		'carbon monoxide'	=> CO_MOLAR_MASS,
		# nitrogen dioxide
		'no2'				=> NO2_MOLAR_MASS,
		'nitrogen dioxide'	=> NO2_MOLAR_MASS,
		# alcohols
		'alcohol'			=> ALCOHOLS_MOLAR_MASS,
		'alcohols'			=> ALCOHOLS_MOLAR_MASS,
		# toxic gases
		'toxic'				=> TOXIC_GASES_MOLAR_MASS,
		'toxic gases'		=> TOXIC_GASES_MOLAR_MASS,
		# particulates (PM10)
		'pm10'				=> PM10_MOLAR_MASS,
		# particulates (PM2.5)
		'pm25'				=> PM25_MOLAR_MASS,
		'pm2.5'				=> PM25_MOLAR_MASS
	}

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
		return temperature + 273.15
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
			raise ArgumentError.new('altitude cannot be negative.')
		end

		if altitude >= 20000
			raise ArgumentError.new('altitude must be less than 20000.')
		end

		layer, index = self.get_altitude_layer(altitude)

		sp = STATIC_PRESSURES[index]
		st = STANDARD_TEMPERATURES[index]
		tlr = TEMPERATURE_LAPSE_RATES[index]

		Rails.logger.debug('sp:' + String(sp) + ', st:' + String(st) + ', tlr:' + String(tlr) + ', h:' + String(altitude) + ', hb:' + String(layer))

		if tlr === 0
			pressure = self.calc_pressure_zero(sp, st, tlr, altitude, layer)
		else
			pressure = self.calc_pressure_non_zero(sp, st, tlr, altitude, layer)
		end

		return pressure
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
		molar_mass = self.get_molar_mass(gas)
		pressure = self.calc_pressure(altitude)

		# <http://antoine.frostburg.edu/chem/senese/101/solutions/faq/converting-ppm-to-micrograms-per-cubic-meter.shtml>
		return (molar_mass * pressure) / (UNIVERSAL_GAS_CONSTANT * temperature)
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
		density = self.calc_density(gas, temperature, altitude)
		return concentration * density
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
		density = self.calc_density(gas, temperature, altitude)
		return concentration / density
	end

	private
		##
		# Gets the molar mass of a gas.
		#
		# Params:
		#   gas (String): The name of the gas.
		#
		# Returns:
		#   (Number): The molar mass in grams per mole.
		##
		def self.get_molar_mass(gas)
			return GASES[gas.downcase]
		end

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
			last, last_index = 0, 0

			ALTITUDE_LAYERS.each_with_index do |layer, index|
				if altitude <= layer
					break
				end

				last, last_index = layer, index
			end

			return last, last_index
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

			return sp * Math.exp((-g * m * (h - hb)) / (r * st))
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

			return sp * ((st / (st + (tlr * (h - hb)))) ** ((g * m) / (r * tlr)))
		end
end
