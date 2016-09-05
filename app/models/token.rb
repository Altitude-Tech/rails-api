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
  # validates(:expires, allow_nil: true, token_expiry: true)
  validates(:enabled, presence: true)

  ##
  #
  ##
  def disable!
    self[:enabled] = false
    self.save!
  end

  ##
  #
  ##
  def generate_token
    self[:token] = SecureRandom.hex
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
    return self[:expires] > Time.now.utc
  end
end
