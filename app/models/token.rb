##
#
##
class Token < ApplicationRecord
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
  #
  ##
  def disable!
    self[:enabled] = false
    save!(validate: false)
  end

  ##
  #
  ##
  def generate_token
    self[:token] = SecureRandom.hex

    # set default value for enabled
    self[:enabled] = true if self[:enabled].nil?
  end

  ##
  #
  ##
  def active?
    return enabled? && !expired?
  end

  ##
  #
  ##
  def enabled?
    return self[:enabled]
  end

  ##
  #
  ##
  def expired?
    return false if self[:expires].nil?
    return self[:expires] <= Time.now.utc
  end

  ##
  #
  ##
  def expires=(expires)
    exp = Time.at(expires).utc.to_s(:db)
    self[:expires] = exp
  rescue TypeError, ArgumentError
    # set the original value so we can access it in the validator
    self[:expires] = expires
  end

  ##
  #
  ##
  def expires
    return Time.parse(self[:expires].to_s).utc.to_formatted_s
  rescue ArgumentError
    return nil
  end
end
