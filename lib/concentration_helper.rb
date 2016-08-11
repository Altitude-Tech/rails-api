class ConcentrationHelper
	##
	# Molar masses of supported gases
	##
	@molecular_weights = {
		'carbon_monoxide' => 28.01,
		'nitrogen_dioxide' => 46.0055
	}

	##
	# Aliases for supported gases
	##
	@gas_aliases = {
		# carbon monoxide
		'co' => 'carbon_monoxide',
		'no2' => 'nitrogen_dioxide',
	}

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
		density = calc_density(gas, temperature, altitude)
		return concentration / density
	end

	##
	# Converts a temperature in centigrade to kelvin.
	##
	def self.centigrade_to_kelvin(temperature)
		return temperature + 273.15
	end

	##
	# Converts a pressure in pascals to atmospheres.
	##
	def self.pascals_to_atmospheres(pressure)
		return pressure / 101325
	end

	private
		##
		# Gets the molar mass of a given gas.
		#
		# Params:
		#   gas (String): The name of the gas.
		#
		# Returns:
		#   (Number): The molar mass in grams per mole.
		##
		def self.get_molar_mass(gas)
			gas = gas.downcase.gsub(' ', '_')

			if @gas_aliases.key? gas
				gas = @gas_aliases[gas]
			end

			return @molecular_weights[gas]
		end

		##
		# Calculates air pressure.
		#
		# Params:
		#   altitude (Number): The altitude in metres.
		#
		# Returns:
		#   (Number): The pressure in atmospheres.
		##
		def self.calc_pressure(altitude)
			# <http://www.engineeringtoolbox.com/air-altitude-pressure-d_462.html>
			return (1 - (2.25577 / 1e5) * altitude) ** 5.25588;
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
		#   (Number): The density in micrograms per centimetres cubed.
		##
		def self.calc_density(gas, temperature, altitude)
			molar_mass = get_molar_mass(gas)
			pressure = calc_pressure(altitude)
			ideal_gas_law_constant = 82.06

			# <http://antoine.frostburg.edu/chem/senese/101/solutions/faq/converting-ppm-to-micrograms-per-cubic-meter.shtml>
			return (molar_mass * pressure * 1e6) / (ideal_gas_law_constant * temperature)
		end
end