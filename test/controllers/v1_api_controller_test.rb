##
# V1ApiController tests
##

require 'test_helper'

class V1ApiControllerTest < ActionController::TestCase
  ##
  #
  ##
  test 'integer too low' do
    assert_raises(ArgumentError) do
      V1ApiController.new.send(:validate_int, 0, 1, 5)
    end
  end

  ##
  #
  ##
  test 'integer too high' do
    assert_raises(ArgumentError) do
      V1ApiController.new.send(:validate_int, 6, 1, 5)
    end
  end

  ##
  # Test
  ##
  test 'non integer' do
    assert_raises(ArgumentError) do
      V1ApiController.new.send(:validate_int, 'invalid', 1, 5)
    end
  end

  ##
  #
  ##
  test 'lower integer' do
    expected = 1

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, 1, 1, 5)

      assert_equal(expected, actual)
    end
  end

  ##
  #
  ##
  test 'upper integer' do
    expected = 5

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, 5, 1, 5)

      assert_equal(expected, actual)
    end
  end

  ##
  #
  ##
  test 'lower integer from string' do
    expected = 1

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, '1', 1, 5)

      assert_equal(expected, actual)
    end
  end

  ##
  #
  ##
  test 'upper integer from string' do
    expected = 5

    assert_nothing_raised do
      actual = V1ApiController.new.send(:validate_int, '5', 1, 5)

      assert_equal(expected, actual)
    end
  end
end
