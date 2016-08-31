##
#
##
class Key < ApplicationRecord
  ##
  # Validations
  ##
  validates(:public_key, uniqueness: true)
  validates(:private_key, presence: true)
  validates(:type, presence: true)
  validates(:expires, presence: true)
  validates(:valid, presence: true)

  ##
  # Constants
  ##
  TYPE_API = 1
  TYPE_DEVICE = 2
  TYPE_PASSWORD_RESET = 3
  TYPE_SESSION = 4

  ##
  #
  ##
  def generate_token
  end

  ##
  #
  ##
  def set_defaults
  end
end
