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
  #
  ##
  test 'token create success' do
    expires = Time.now.utc + 1.day

    Token.create!(expires: expires)
  end

  ##
  # Test error handling
  ##
  test 'token create historic date' do
    historic = Time.now.utc - 1.day

    assert_raises(ActiveRecord::RecordInvalid) do
      token = Token.create!(expires: historic)
    end
  end

  ##
  #
  ##
  test 'token create non-expiring' do
    token = Token.create!
  end

  ##
  #
  ##
  test 'token create invalid date' do
    assert_raises(ActiveRecord::RecordInvalid) do
      token = Token.create!(expires: 'invalid')
    end
  end
end
