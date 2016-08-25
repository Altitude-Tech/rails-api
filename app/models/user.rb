##
# Model representing a user
##
class User < ApplicationRecord
  has_secure_password

  ##
  # Validations
  ##
  validates(:name, presence: true)
  validates(:email, presence: true)
  validates(:password, length: { minimum: 8 })
  validates(:password_digest, presence: true)
end
