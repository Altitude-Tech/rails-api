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
    save(validate: false)
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
    return self.enabled? && !self.expired?
  end

  ##
  #
  ##
  def enabled?
    return !!self[:enabled]
  end

  ##
  #
  ##
  def expired?
    return false if self[:expires].nil?
    return self[:expires] <= Time.now.utc
  end
end
