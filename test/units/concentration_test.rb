require 'test_helper'
require 'concentration'

class ConcentrationTest < Minitest::Test
	def test_centrigrade_to_kelvin
		expected = 273.15
		actual = Concentration.centigrade_to_kelvin(0)

		assert_equal expected, actual
	end

	def test_calc_pressure_normal_bounds_1_0
		expected = 101325.00
		actual = Concentration.calc_pressure(0)

		assert_equal expected, actual.round(2)
	end

	def test_calc_pressure_normal_bounds_2_500
		expected = 95460.93
		actual = Concentration.calc_pressure(500)

		assert_equal expected, actual.round(2)
	end

	def test_calc_pressure_normal_bounds_3_1000
		expected = 89874.74
		actual = Concentration.calc_pressure(1000)

		assert_equal expected, actual.round(2)
	end

	def test_calc_pressure_normal_bounds_4_1500
		expected = 84556.24
		actual = Concentration.calc_pressure(1500)

		assert_equal expected, actual.round(2)
	end

	def test_calc_pressure_extremes_1_10000
		expected = 26436.82
		actual = Concentration.calc_pressure(10000)

		assert_equal expected, actual.round(2)
	end

	def test_calc_pressure_extremes_2_15000
		expected = 12044.71
		actual = Concentration.calc_pressure(15000)

		assert_equal expected, actual.round(2)
	end

	def test_calc_pressure_min
		assert_raises(ArgumentError) do
			Concentration.calc_pressure(-1)
		end
	end

	def test_calc_pressure_max
		assert_raises(ArgumentError) do
			Concentration.calc_pressure(20000)
		end
	end

	def test_co_ppm_to_ugm3
		conc_ppm = 1000
		gas = 'carbon monoxide'
		temperature = 273.15
		altitude = 0

		expected = 1249668.98
		actual = Concentration.ppm_to_ugm3(conc_ppm, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

	def test_no2_ppm_to_ugm3
		conc_ppm = 1000
		gas = 'nitrogen dioxide'
		temperature = 273.15
		altitude = 0

		expected = 2052540.03
		actual = Concentration.ppm_to_ugm3(conc_ppm, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

	def test_co_ugm3_to_ppm
		conc_ugm3 = 2000000
		gas = 'carbon monoxide'
		temperature = 273.15
		altitude = 0

		expected = 1600.42
		actual = Concentration.ugm3_to_ppm(conc_ugm3, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

	def test_no2_ugm3_to_ppm
		conc_ugm3 = 2000000
		gas = 'nitrogen dioxide'
		temperature = 273.15
		altitude = 0

		expected = 974.40
		actual = Concentration.ugm3_to_ppm(conc_ugm3, gas, temperature, altitude)

		assert_equal expected, actual.round(2)
	end

end
