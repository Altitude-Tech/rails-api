require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  ##
  # Data to use for creating a new token.
  ##
  CREATE_DATA = {
    expires: 1.hour.from_now
  }.freeze

  ##
  # Test success of `create!` method.
  ##
  test 'create! success' do
    data = CREATE_DATA.deep_dup

    token = Token.create! data

    assert token.active?
    assert_equal token.expires.to_s, data[:expires].to_s
  end

  ##
  # Test error handling of `create!` method for invalid `expires` attribute.
  ##
  test 'create! expires invalid' do
    data = CREATE_DATA.deep_dup
    data[:expires] = 'invalid'

    assert_raises ActiveRecord::RecordInvalid do
      Token.create! data
    end
  end

  ##
  # Test error handling of `create!` method for historic `expires` attribute.
  ##
  test 'create! expires historic' do
    data = CREATE_DATA.deep_dup
    data[:expires] = 1.hour.ago

    assert_raises ActiveRecord::RecordInvalid do
      Token.create! data
    end
  end

  ##
  # Test success of `create!` method for missing `expires` attribute.
  ##
  test 'create! success expires missing' do
    token = Token.create!

    assert token.active?
    assert token.expires.nil?
  end

  ##
  #
  ##
  test 'disable! success' do
    data = CREATE_DATA.deep_dup
    token = Token.create! data

    assert token.active?
    assert token.enabled

    token.disable!

    assert_not token.active?
    assert_not token.enabled
  end

  ##
  #
  ##
  test 'active? enabled and expires in the future' do
    data = CREATE_DATA.deep_dup
    token = Token.create! data

    assert token.active?
    assert token.enabled
    assert token.expires > Time.now.utc
  end

  ##
  #
  ##
  test 'active? disabled and expires in the future' do
    data = CREATE_DATA.deep_dup
    token = Token.create! data
    token.disable!

    assert_not token.active?
    assert_not token.enabled
    assert token.expires > Time.now.utc
  end

  ##
  #
  ##
  test 'active? enabled and expired' do
    token = Token.new
    token.expires = 1.hour.ago
    token.send :generate_token
    token.save! validate: false

    assert_not token.active?
    assert token.enabled
    assert_not token.expires > Time.now.utc
  end

  ##
  #
  ##
  test 'active? disabled and expired' do
    token = Token.new
    token.expires = 1.hour.ago
    token.send :generate_token
    token.save! validate: false
    token.disable!

    assert_not token.active?
    assert_not token.enabled
    assert_not token.expires > Time.now.utc
  end

  ##
  #
  ##
  test 'active? enabled and expires is nil' do
    token = Token.create!

    assert token.active?
    assert token.enabled
    assert token.expires.nil?
  end

  ##
  #
  ##
  test 'active? disabled and expires is nil' do
    token = Token.create!
    token.disable!

    assert_not token.active?
    assert_not token.enabled
    assert token.expires.nil?
  end
end
