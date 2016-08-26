##
#
#
# @todo add a way of undoing update/change_password
#       investigate <https://github.com/collectiveidea/audited>
##
module V1
  ##
  #
  ##
  class UsersController < V1ApiController
    ##
    # Create a new user
    ##
    def create
      User.create!(@json)

      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    ##
    # Get a list of users
    ##
    def index
    end

    ##
    # Get details for a specific user
    ##
    def show
      logger.debug(@json[:email])
    end

    ##
    # For updating a user's name or email
    ##
    def update
      msg = 'This access point does not support changing a password.'
      raise V1ApiError, msg if @json.key?(:password)

      user = User.find_by_email!(@json[:email])

      attrs = @json.slice(:new_email, :name)
      attrs[:email] = attrs.delete(:new_email)

      user.update!(attrs)

      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    ##
    # Change a user's password
    ##
    def change_password
    end

    ##
    # Authenticate a user's password
    ##
    def authenticate
    end
  end
end
