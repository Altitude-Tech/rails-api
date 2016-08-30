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
  # Test conversion of a hash with a hash
  ##
  test 'normalize hash nested' do
    input = { 'a' => { 'a' => 1, 'b' => 2 } }
    expected = { a: { a: 1, b: 2 } }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end

  ##
  # Test conversion of an array within a hash
  ##
  test 'normalize hash nested array' do
    input = { 'a' => [1, 2, 3] }
    expected = { a: [1, 2, 3] }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end

  ##
  # Test conversion of a hash withion an array within a hash
  ##
  test 'normalize hash nested array hashes' do
    input = { 'a' => [{ 'a' => 1, 'b' => 2 }] }
    expected = { a: [{ a: 1, b: 2 }] }

    actual = V1ApiController.new.send(:normalize_keys, input)
    assert_equal(expected, actual)
  end

  ##
  # Test error handling of StandardError in test mode
  ##
  test 'handle standard error test' do
    exc = StandardError.new('test')

    assert_raises(StandardError) do
      V1ApiController.new.send(:standard_error, exc)
    end
  end

  ##
  # Test error handling of StandardError in development mode
  #
  # What's probably meant to happen here is mock the controller somehow
  # but instead, this sends the expected argument to the standard_error method
  # then catches the expected error.
  #
  # After that, the error message is tested to get the error message.
  ##
  test 'handle standard error development' do
    exc = StandardError.new('test')
    error_regex = /@error="(.*?)"/
    msg = I18n.t('controller.v1.error.unhandled_error')

    ENV['RAILS_ENV'] = 'production'

    begin
      V1ApiController.new.send(:standard_error, exc)
    rescue Module::DelegationError => e
      error_match = error_regex.match(e.message)
      assert_equal(error_match.captures[0], msg)
    end

    ENV['RAILS_ENV'] = 'test'
  end

  ##
  # Test error handling of StandardError in production mode
  #
  # What's probably meant to happen here is mock the controller somehow
  # but instead, this sends the expected argument to the standard_error method
  # then catches the expected error.
  #
  # After that, the error message is tested to get the error message.
  ##
  test 'handle standard error production' do
    exc = StandardError.new('test')
    error_regex = /@error="(.*?)"/
    msg = I18n.t('controller.v1.error.unhandled_error')

    ENV['RAILS_ENV'] = 'production'

    begin
      V1ApiController.new.send(:standard_error, exc)
    rescue Module::DelegationError => e
      error_match = error_regex.match(e.message)
      assert_equal(error_match.captures[0], msg)
    end

    ENV['RAILS_ENV'] = 'test'
  end
end
