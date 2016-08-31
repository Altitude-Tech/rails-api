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
      msg = I18n.t('models.users.error.password_digest')
      raise ArgumentError, msg
    end

    super(args)
  end

  ##
  # Override default method to prevent explicitly updating password_digest
  ##
  def update!(args)
    if args.key?(:password_digest)
      msg = I18n.t('models.users.error.password_digest')
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
      msg = I18n.t('models.users.error.password')
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
  def update_details!(params)
    if params.key?(:password)
      msg = 'This method does not support changing passwords.'
      raise ArgumentError, msg
    end

    params[:email] = params.delete(:new_email) if params.key?(:new_email)

    update!(params)
  end
end
