##
# Model representing a user
##
class User < ApplicationRecord
  has_secure_password

  ##
  # Associations
  ##
  belongs_to(:token, foreign_key: :session_token, optional: true)
  belongs_to(:group, foreign_key: :group_id, optional: true)
  has_one(:group, foreign_key: :admin)

  ##
  # Validations
  ##
  validates(:name, presence: true, length: { maximum: 255 })
  validates(:email, uniqueness: true, format: { with: /@/ }, length: { maximum: 255 })
  validates(:password, length: { minimum: 8 }, allow_nil: true)
  validates(:password_digest, presence: true)

  ##
  # Constants
  ##
  UPDATE_ATTRS = [:name].freeze

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
  # Override default method to look up by token column instead
  ##
  def self.find_by_session_token!(session_token)
    token = Token.find_by_token!(session_token)
    user = token.user

    raise ActiveRecord::RecordNotFound if user.nil?
    return token.user
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
    # don't try to update the email address as it won't vary
    params.delete(:email)
    not_allowed = params.slice!(*UPDATE_ATTRS)

    unless not_allowed.empty?
      msg = I18n.t('models.users.error.not_supported', key: not_allowed.keys.first)
      raise ArgumentError, msg
    end

    update!(params)
  end

  ##
  # Generate a new session token
  ##
  def create_session_token!
    expires = Time.now.utc + 6.hours
    token = Token.create!(expires: expires)

    update!(session_token: token.id)
  end

  ##
  # Getter for session_token
  ##
  def session_token
    return nil if self[:session_token].nil?
    return Token.find(self[:session_token])
  end

  ##
  # Test if the user has an active session token
  ##
  def logged_in?
    return session_token && session_token.active?
  end
end
