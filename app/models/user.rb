require 'exceptions/record_exceptions'

##
# Represents a user in the database.
##
class User < ApplicationRecord
  ##
  # See <http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html>
  # Note that the `password_confirmation` attribute is not used.
  ##
  has_secure_password

  ##
  # Associations
  ##
  belongs_to :token, foreign_key: :session_token, optional: true
  belongs_to :group, foreign_key: :group_id, optional: true
  has_one :group, foreign_key: :admin

  ##
  # Validations
  ##
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: true, length: { minimum: 3, maximum: 255 }, format: { with: /@/ }
  validates :password, length: { minimum: 8, maximum: 72 }, allow_nil: true

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

    # set and return a session token
    token = Token.create! expires: 6.hours.from_now
    update! session_token: token.token

    return token
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
end
