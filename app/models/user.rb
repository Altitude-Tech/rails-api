##
# Model representing a user
##
class User < ApplicationRecord
  validates(:name, presence: true)
  validates(:email, presence: true)
  validates(:password_hash, presence: true)

  ##
  # Convert a password into a hash wth bcrypt
  ##
  def password=(password)
    # @todo <https://github.com/Altitude-Tech/sensly-api/blob/master/app/models/user.rb>
  end

  ##
  #
  ##
  def password
  end
end
