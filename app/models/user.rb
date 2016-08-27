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
  validates(:password, length: { minimum: 8 })
  validates(:password_digest, presence: true)

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
  # @todo <alias_method :parent_method, :method>
  ##
  def update(params=nil)
    if params.key?(:password)
      msg = 'password cannot be updated this way'
      raise ArgumentError, msg
    end

    if params.key?[:new_email]
      params[:email] = params.delete[:new_email]
    end

    super(params)
  end

  def update!(params=nil)
  end

  ##
  #
  ##
  def change_password(old_password, new_password)
    self.authenticate!(old_password)


  end
end
