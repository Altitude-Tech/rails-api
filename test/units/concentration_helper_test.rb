require 'test_helper'
require 'concentration_helper'

class ConcentrationHelperTest < Minitest::Test
	def setup
		@conc_helper = ConcentrationHelper
	end

	def test_centrigrade_to_kelvin
		zero_centigrade = 0
		zero_kelvin = 273.15

		converted = @conc_helper.centigrade_to_kelvin(zero_centigrade)

		assert_equal zero_kelvin, converted
	end

	def test_pascals_to_atmospheres
		one_pascal = 101325
		one_atmosphere = 1

		converted = @conc_helper.pascals_to_atmospheres(one_pascal)

		assert_equal one_atmosphere, converted
	end

	def test_co_ppm_to_ugm3
		ppm = 1000
		gas = 'carbon monoxide'
		temperature = 273.15
		altitude = 0

		concentration = @conc_helper.ppm_to_ugm3(ppm, gas, temperature, altitude)
		expected = 1249626.9745254999

		assert_equal expected, concentration
	end

	def test_no2_ppm_to_ugm3
		ppm = 1000
		gas = 'nitrogen dioxide'
		temperature = 273.15
		altitude = 0

		concentration = @conc_helper.ppm_to_ugm3(ppm, gas, temperature, altitude)
		expected = 2052471.038076861

		assert_equal expected, concentration
	end

	def test_co_ugm3_to_ppm
	end

	def test_no2_ugm3_to_ppm
	end
end
