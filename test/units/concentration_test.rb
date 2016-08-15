##
# Concentration tests
##

require 'test_helper'
require 'concentration'

class ConcentrationTest < Minitest::Test
	##
	# Test temperature conversion from centigrade to kelvin
	##
	def test_centrigrade_to_kelvin
		expected = 273.15
		actual = Concentration.centigrade_to_kelvin(0)

		assert_equal expected, actual
	end

	##
	# Test pressure calculation at 0m
	##
	def test_calc_pressure_normal_bounds_1_0
		expected = 101325.00
		actual = Concentration.calc_pressure(0)

		assert_equal expected, actual.round(2)
	end

	##
	# Test pressure calculation at 500m
	##
	def test_calc_pressure_normal_bounds_2_500
		expected = 95460.93
		actual = Concentration.calc_pressure(500)

		assert_equal expected, actual.round(2)
	end

	##
	# Test pressure calculation at 1km
	##
	def test_calc_pressure_normal_bounds_3_1000
		expected = 89874.74
		actual = Concentration.calc_pressure(1000)

		assert_equal expected, actual.round(2)
	end

	##
	# Test pressure calculation at 1.5km
	#
	# This is the limit of 'normal' usage as the highest point in UK is 1344m
	##
	def test_calc_pressure_normal_bounds_4_1500
		expected = 84556.24
		actual = Concentration.calc_pressure(1500)

		assert_equal expected, actual.round(2)
	end

	##
	# Test pressure calculation at 10km
	#
	# This is above Mt. Everest (8848m) so it should never be higher than this
	##
	def test_calc_pressure_extremes_1_10000
		expected = 26436.82
		actual = Concentration.calc_pressure(10000)

		assert_equal expected, actual.round(2)
	end

	##
	# Test pressure calculation at 15km
	#
	# For testing the pressure equation when the standard temperature lapse rate is 0
	##
	def test_calc_pressure_extremes_2_15000
		expected = 12044.71
		actual = Concentration.calc_pressure(15000)

		assert_equal expected, actual.round(2)
	end

	##
	# Test enforcement of minimum limit in pressure calculation
	##
	def test_calc_pressure_min
		assert_raises(ArgumentError) do
			Concentration.calc_pressure(-1)
		end
	end

	##
	# Test enforcement of maximum limit in pressure calculation
	##
	def test_calc_pressure_max
		assert_raises(ArgumentError) do
			Concentration.calc_pressure(20000)
		end
	end

	##
	# Test concentration conversion of carbon monoxide from parts per million to micrograms per
	# metres cubed
	##
	def test_co_ppm_to_ugm3
		conc_ppm = 1000
		gas = GAS_CARBON_MONOXIDE
		temperature = 273.15
		altitude = 0

		expected = 1249668.98
		actual = Concentration.ppm_to_ugm3(conc_ppm, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

	##
	# Test concentration conversion of nitrogen dioxide from parts per million to micrograms per
	# metres cubed
	##
	def test_no2_ppm_to_ugm3
		conc_ppm = 1000
		gas = GAS_NITROGEN_DIOXIDE
		temperature = 273.15
		altitude = 0

		expected = 2052540.03
		actual = Concentration.ppm_to_ugm3(conc_ppm, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

	##
	# Test concentration conversion of carbon monoxide from micrograms per metres cubed to parts
	# per million
	##
	def test_co_ugm3_to_ppm
		conc_ugm3 = 2000000
		gas = GAS_CARBON_MONOXIDE
		temperature = 273.15
		altitude = 0

		expected = 1600.42
		actual = Concentration.ugm3_to_ppm(conc_ugm3, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

	##
	# Test concentration conversion of nitrogen dioxide from micrograms per metres cubed to parts
	# per million
	##
	def test_no2_ugm3_to_ppm
		conc_ugm3 = 2000000
		gas = GAS_NITROGEN_DIOXIDE
		temperature = 273.15
		altitude = 0

		expected = 974.40
		actual = Concentration.ugm3_to_ppm(conc_ugm3, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

end
