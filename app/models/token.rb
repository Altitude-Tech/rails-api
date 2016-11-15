##
# Represents a token in the database.
#
# Tokens can either expire naturally, but setting the `expires` attribute in the future
# and witing for it to expire, or can be manually disabled by using the `disable!` method.
#
# If a token should never expire based on time, set the `expires` attribute to `nil`.
# The only way to disable such tokens is to do so manually.
##
class Token < ApplicationRecord
  ##
  # Set a custom primary key.
  #
  # Set this way because rails makes it awkwardly difficult to change the primary key from `id`.
  # As a workaround, `token` is `UNIQUE` and indexed and then set as the primary key here.
  ##
  self.primary_key = :token

  ##
  # Associations
  ##
  has_one :user, foreign_key: :session_token
  has_one :device, foreign_key: :token

  ##
  # Callbacks
  ##
  before_validation :generate_token

  ##
  # Validations
  ##
  validates :token, presence: true
  validates :expires, datetime: { min: Time.now.utc, allow_null: true }
  validates :enabled, inclusion: { in: [true, false] }

  ##
  # Test if the token is enabled and not expired.
  ##
  def active?
    not_expired = self[:expires].nil? || self[:expires] > Time.now.utc
    return self[:enabled] && not_expired
  end

  ##
  # Mark a token as disabled.
  #
  # Skips validations to prevent expired tokens failing to update.
  ##
  def disable!
    self[:enabled] = false
    save! validate: false
  end

  def self.csrf!
    return Token.create! expires: 10.minutes.from_now
  end

  private

  ##
  # Generate a new token if it does not already exist.
  ##
  def generate_token
    self[:token] ||= SecureRandom.hex
  end
end
