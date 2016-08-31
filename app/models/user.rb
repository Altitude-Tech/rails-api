##
# Model representing a user
##
class User < ApplicationRecord
  has_secure_password

  ##
  # Validations
  ##
  validates(:name, presence: true)
  validates(:email, uniqueness: true, format: { with: /@/ })
  validates(:password, length: { minimum: 8 }, allow_nil: true)
  validates(:password_digest, presence: true)

  ##
  # Override default method to prevent explicitly updating password_digest
  ##
  def self.create!(args)
    if args.key?(:password_digest)
      msg = 'password_digest cannot be explicitly updated.'
      raise ArgumentError, msg
    end

    super(args)
  end

  ##
  # Override default method to prevent explicitly updating password_digest
  ##
  def update!(args)
    if args.key?(:password_digest)
      msg = 'password_digest cannot be explicitly updated.'
      raise ArgumentError, msg
    end

    super(args)
  end

  ##
  #
  ##
  def authenticate!(password)
    user = authenticate(password)

    if user == false
      msg = 'incorrect password'
      raise ArgumentError, msg
    end

    return user
  end

  ##
  #
  ##
  def change_password!(old_password, new_password)
    authenticate!(old_password)
    update!(password: new_password)
  end

  ##
  #
  ##
  def change_details!(params)
    if params.key?(:password)
      msg = 'This method does not support changing passwords.'
      raise ArgumentError, msg
    end

    update!(params)
  end
end
