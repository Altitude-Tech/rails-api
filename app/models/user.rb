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

  ##
  #
  ##
  def authenticate!(password)
    user = authenticate(password)

    raise ArgumentError, 'incorrect password' if user == false
    return user
  end

  ##
  #
  ##
  def update(params=nil)
    super(params)
  end
end
