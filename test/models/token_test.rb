require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  ##
  # Test an active token
  ##
  test 'token active' do
    token = Token.first!

    assert_equal(true, token.active?)
  end

  ##
  # Test disabling of a token
  ##
  test 'token disable' do
    token = Token.first!
    token.disable!

    assert_equal(false, token.active?)
    assert_equal(false, token.enabled?)
  end

  ##
  # Test how an expired token is handled
  ##
  test 'token expired' do
    token = Token.find(2)

    assert_equal(false, token.active?)
    assert_equal(true, token.expired?)
  end

  ##
  # Test successful token creation
  ##
  test 'token create success' do
    expires = Time.now.utc + 1.day

    token = Token.create!(expires: expires)

    assert_equal(expires.to_formatted_s, token.expires)
    assert_equal(true, token.active?)
  end

  ##
  # Test error handling for token creation with historic dates for expires
  ##
  test 'token create historic date' do
    historic = Time.now.utc - 1.day

    assert_raises(ActiveRecord::RecordInvalid) do
      Token.create!(expires: historic)
    end
  end

  ##
  # Test creation for non-expiring tokens
  ##
  test 'token create non-expiring' do
    token = Token.create!

    assert_equal(true, token.active?)
    assert_equal(nil, token.expires)
  end

  ##
  # Test error handling for token creation with invalid expires
  ##
  test 'token create invalid date' do
    assert_raises(ActiveRecord::RecordInvalid) do
      Token.create!(expires: 'invalid')
    end
  end

  ##
  #
  ##
  test 'token create duplicate' do
    token = Token.first!

    assert_raises(ActiveRecord::RecordInvalid) do
      Token.create(token: token.token)
    end
  end
end
