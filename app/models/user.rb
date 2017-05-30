require 'exceptions/record_exceptions'

##
# Represents a user in the database.
##
class User < ApplicationRecord
  ##
  # Constants
  ##
  UPDATE_ATTRS = [
    :name
  ].freeze

  ##
  # See <http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html>
  # Note that the `password_confirmation` attribute is not used.
  ##
  has_secure_password

  ##
  # Associations
  ##
  belongs_to :token, foreign_key: :session_token, optional: true
  belongs_to :token, foreign_key: :confirm_token, optional: true
  belongs_to :token, foreign_key: :reset_token, optional: true
  belongs_to :group, foreign_key: :group_id, optional: true
  has_one :group, foreign_key: :admin

  ##
  # Validations
  ##
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :email,
            uniqueness: { message: I18n.t('errors.in_use') },
            length: { minimum: 3, maximum: 255 },
            format: { with: /@/ }
  validates :password,
            length: { minimum: 8, maximum: 72 },
            allow_nil: true
  validates :staff,
            inclusion: { in: [true, false] }

  ##
  # Setter for `email` addresses.
  #
  # Normalises email address to lowercase.
  ##
  def email=(value)
    self[:email] = value.downcase
  rescue NoMethodError
    self[:email] = value
  end

  ##
  # Setter for `group`.
  ##
  def group=(value)
    unless self[:group_id].nil?
      msg = 'User is already a member of a group.'
      raise Record::GroupMemberError, msg
    end

    if value.is_a? Group
      self[:group_id] = value.id
      return
    end

    self[:group_id] = value
  end

  ##
  # Getter for group.
  ##
  def group
    if self[:group_id].nil?
      return self[:group_id]
    end

    return Group.find self[:group_id]
  end

  ##
  # Authenticate a user with `password` and return a new `session_token` if successful.
  ##
  def authenticate!(password)
    user = authenticate password

    if user == false
      msg = 'Incorrect password.'
      raise Record::UserAuthError, msg
    end

    unless self[:confirm_token].nil?
      msg = 'Unconfirmed email address.'
      raise Record::UserUnconfirmedError, msg
    end

    # set and return a session token
    token = Token.create! expires: 6.hours.from_now
    update! session_token: token.token

    return token
  end

  ##
  # Generate a new confirm token.
  #
  # Will disable any existing token should it already exist.
  ##
  def generate_confirm_token!
    unless self[:confirm_token].nil?
      token = Token.find(self[:confirm_token])
      token.disable!

      update! confirm_token: nil
    end

    token = Token.create! expires: 24.hours.from_now
    update! confirm_token: token.token
  end

  def remove_confirm_token!
    unless self[:confirm_token].nil?
      token = Token.find(self[:confirm_token])
      token.disable!

      update! confirm_token: nil
    end
  end


  ##
  # Disable the session token and remove it from the user.
  ##
  def reset_session_token!
    unless self[:session_token].nil?
      # disable the token to prevent re-use
      token = Token.find(self[:session_token])
      token.disable!

      update! session_token: nil
    end
  end

  ##
  #
  ##
  def update_details!(attrs)
    attrs.each do |k, _|
      msg = "Unable to update attribute \"#{k}\"."
      raise Record::UpdateError, msg unless UPDATE_ATTRS.include? k
    end

    update! attrs
  end
end
