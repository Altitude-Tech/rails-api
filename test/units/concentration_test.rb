##
#
##

require 'test_helper'
require 'concentration'

##
# Concentration tests
##
class ConcentrationTest < Minitest::Test
  ##
  # Test temperature conversion from centigrade to kelvin
  ##
  def test_centrigrade_to_kelvin
    expected = 273.15
    actual = Concentration.centigrade_to_kelvin(0)

    assert_equal(expected, actual)
  end

  ##
  # Test concentration conversion of carbon monoxide from parts per million
  # to micrograms per metres cubed
  ##
  def test_co_ppm_to_ugm3
    conc_ppm = 1000
    gas = GAS_CARBON_MONOXIDE
    temperature = 273.15
    pressure = 101_325.00

    expected = 1_249_668.98
    actual = Concentration.ppm_to_ugm3(conc_ppm, gas, temperature, pressure)

    assert_equal(expected, actual.round(2))
  end

  ##
  # Test concentration conversion of nitrogen dioxide from parts per million
  # to micrograms per metres cubed
  ##
  def test_no2_ppm_to_ugm3
    conc_ppm = 1000
    gas = GAS_NITROGEN_DIOXIDE
    temperature = 273.15
    pressure = 101_325.00

    expected = 2_052_540.03
    actual = Concentration.ppm_to_ugm3(conc_ppm, gas, temperature, pressure)

    assert_equal(expected, actual.round(2))
  end

  ##
  # Test concentration conversion of carbon monoxide from micrograms per
  # metres cubed to parts per million
  ##
  def test_co_ugm3_to_ppm
    conc_ugm3 = 2_000_000
    gas = GAS_CARBON_MONOXIDE
    temperature = 273.15
    pressure = 101_325.00

    expected = 1600.42
    actual = Concentration.ugm3_to_ppm(conc_ugm3, gas, temperature, pressure)

    assert_equal(expected, actual.round(2))
  end

  ##
  # Test concentration conversion of nitrogen dioxide from micrograms per
  # metres cubed to parts per million
  ##
  def test_no2_ugm3_to_ppm
    conc_ugm3 = 2_000_000
    gas = GAS_NITROGEN_DIOXIDE
    temperature = 273.15
    pressure = 101_325.00

    expected = 974.40
    actual = Concentration.ugm3_to_ppm(conc_ugm3, gas, temperature, pressure)

    assert_equal(expected, actual.round(2))
  end
end
