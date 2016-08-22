##
# V1ApiController tests
##

require 'test_helper'

class V1ApiControllerTest < ActionController::TestCase
  ##
  # Test error handling for input below lower limit
  ##
  test 'integer too low' do
    assert_raises(ArgumentError) do
      V1ApiController.new.send(:validate_int, 0, 1, 5)
    end
  end

  ##
  # Test error handling for input above upper limit
  ##
  test 'integer too high' do
    assert_raises(ArgumentError) do
      V1ApiController.new.send(:validate_int, 6, 1, 5)
    end
  end

  ##
  # Test error handling for non-integerinput
  ##
  test 'non integer' do
    assert_raises(ArgumentError) do
      V1ApiController.new.send(:validate_int, 'invalid', 1, 5)
    end
  end

  ##
  # Test error handling for input at lower limit
  ##
  test 'lower integer' do
    expected = 1

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, 1, 1, 5)
      assert_equal(expected, actual)
    end
  end

  ##
  # Test error handling for input at upper limit
  ##
  test 'upper integer' do
    expected = 5

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, 5, 1, 5)
      assert_equal(expected, actual)
    end
  end

  ##
  # Test error handling for input at lower limit converted from a string
  ##
  test 'lower integer from string' do
    expected = 1

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, '1', 1, 5)
      assert_equal(expected, actual)
    end
  end

  ##
  # Test error handling for input at upper limit converted from a string
  ##
  test 'upper integer from string' do
    expected = 5

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, '5', 1, 5)
      assert_equal(expected, actual)
    end
  end

  ##
  # Test conversion of a simple hash
  ##
  test 'normalize hash simple' do
    input = { 'a' => 1, 'b' => 2, 'c' => 3 }
    expected = { a: 1, b: 2, c: 3 }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end

  ##
  #
  ##
  test 'normalize hash nested' do
    input = { 'a' => { 'a' => 1, 'b' => 2 } }
    expected = { a: { a: 1, b: 2 } }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end

  ##
  #
  ##
  test 'normalize hash nested array' do
    input = { 'a' => [1, 2, 3] }
    expected = { a: [1, 2, 3] }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end

  ##
  #
  ##
  test 'normalize hash nested array hashes' do
    input = { 'a' => [{ 'a' => 1, 'b' => 2 }] }
    expected = { a: [{ a: 1, b: 2 }] }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end
end
