##
# Model representing a user
##
class User < ApplicationRecord
  has_secure_password

  ##
  # Validations
  ##
  validates(:name, presence: true)
  validates(:email, format: { with: /@/ })
  validates(:password, length: { minimum: 8 })
  validates(:password_digest, presence: true)
end
