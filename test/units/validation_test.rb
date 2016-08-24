##
# V1ApiController tests
##

require 'test_helper'
require 'validation'

class ValidationTest < Minitest::Test
  ##
  # Test error handling for input below lower limit
  ##
  def test_integer_too_low
    assert_raises(ArgumentError) do
      Validation.validate_int(0, 1, 5)
    end
  end

  ##
  # Test error handling for input above upper limit
  ##
  def test_integer_too_high
    assert_raises(ArgumentError) do
      Validation.validate_int(6, 1, 5)
    end
  end

  ##
  # Test error handling for non-integerinput
  ##
  def test_non_integer
    assert_raises(ArgumentError) do
      Validation.validate_int('invalid', 1, 5)
    end
  end

  ##
  # Test error handling for input at lower limit
  ##
  def test_lower_integer
    expected = 1

    actual = Validation.validate_int(1, 1, 5)
    assert_equal(expected, actual)
  end

  ##
  # Test error handling for input at upper limit
  ##
  def test_upper_integer
    expected = 5

    actual = Validation.validate_int(5, 1, 5)
    assert_equal(expected, actual)
  end

  ##
  # Test error handling for input at lower limit converted from a string
  ##
  def test_lower_integer_from_string
    expected = 1

    actual = Validation.validate_int('1', 1, 5)
    assert_equal(expected, actual)
  end

  ##
  # Test error handling for input at upper limit converted from a string
  ##
  def test_upper_integer_from_string
    expected = 5

    actual = Validation.validate_int('5', 1, 5)
    assert_equal(expected, actual)
  end

  ##
  # Test success of integer floats
  ##
  def test_integer_float
    expected = 1

    actual = Validation.validate_int(1.0, 1, 2)
    assert_equal(expected, actual)
  end

  ##
  # Test error handling for non-integer floats
  ##
  def test_non_integer_float
    assert_raises(ArgumentError) do
      Validation.validate_int(1.5, 1, 2)
    end
  end

  ##
  # Test error handling when passing in an integer float as a string
  #
  # Technically this should work, but it doesn't seem worth it
  # so test the behaviour and move on
  ##
  def test_string_integer_float
    assert_raises(ArgumentError) do
      Validation.validate_int('1.0', 1, 2)
    end
  end

  ##
  # Test error handling when passing in a non-integer float as a string
  ##
  def test_string_non_integer_float
    assert_raises(ArgumentError) do
      Validation.validate_int('1.5', 1, 2)
    end
  end
end
