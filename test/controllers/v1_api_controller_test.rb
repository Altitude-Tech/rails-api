##
#
##

require 'test_helper'

class V1ApiControllerTest < ActionController::TestCase
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
