##
#
##
class Token < ApplicationRecord
  ##
  # Associations
  ##
  has_one(:user, foreign_key: :session_token)

  ##
  # Callbacks
  ##
  before_validation(:generate_token)

  ##
  # Validations
  ##
  validates(:token, uniqueness: true)
  validates(:expires, token_expiry: true)
  validates(:enabled, inclusion: { in: [true, false] })

  ##
  # Mark a token as disabled
  #
  # To be used to manually invalidate a token instead of letting it expire naturally
  ##
  def disable!
    self[:enabled] = false
    save!(validate: false)
  end

  ##
  # Test if the token is considered active
  ##
  def active?
    return enabled? && !expired?
  end

  ##
  # Test if the token is enabled
  ##
  def enabled?
    return self[:enabled]
  end

  ##
  # Test if the token has expired
  ##
  def expired?
    return false if self[:expires].nil?
    return self[:expires] <= Time.now.utc
  end

  ##
  # Setter for expires attribute
  ##
  def expires=(expires)
    exp = Time.at(expires).utc.to_s(:db)
    self[:expires] = exp
  rescue TypeError, ArgumentError
    # set the original value so we can access it in the validator
    self[:expires] = expires
  end

  ##
  # Getter for expires attribute
  ##
  def expires
    return Time.parse(self[:expires].to_s).utc
  rescue ArgumentError
    return nil
  end

  private

  ##
  # Callback method for generating a new token
  ##
  def generate_token
    self[:token] = SecureRandom.hex if self[:token].nil?

    # set default value for enabled
    self[:enabled] = true if self[:enabled].nil?
  end
end
