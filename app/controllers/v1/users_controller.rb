##
#
##

require 'exceptions'

##
#
##
module V1
  ##
  #
  ##
  class UsersController < V1ApiController
    ##
    # Error handling functions
    ##
    rescue_from(Exceptions::V1ApiRecordInvalid, with: :alternate_record_invalid)

    ##
    # Create a new user
    ##
    def create
      User.create!(@json)

      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    ##
    # Get a specific user's details
    ##
    def show
      @user = User.find_by_email!(params[:email])

      unless @user == user_from_session!
        msg = I18n.t('controller.v1.error.unauthorised')
        raise Exceptions::V1ApiUnauthorisedError, msg
      end
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', params[:email])
    end

    ##
    # Update a user's details
    ##
    def update
      user = User.find_by_email!(params[:email])

      unless user == user_from_session!
        msg = I18n.t('controller.v1.error.unauthorised')
        raise Exceptions::V1ApiUnauthorisedError, msg
      end

      user.update_details!(@json)

      @result = t('controller.v1.message.success')
      render('v1/result')

    # can't find user in database
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', @json[:email])

    # no valid session token was found
    rescue Exceptions::V1ApiInvalidSessionError
      msg = I18n.t('controller.v1.error.unauthorised')
      raise Exceptions::V1ApiUnauthorisedError, msg

    # tried to update non-whitelisted attributes
    rescue Exceptions::UserUpdateError => e
      raise Exceptions::V1ApiError, e.message
    end

    ##
    # Reset a user's password
    ##
    def reset_password
      user = User.find_by_email!(@json[:email])

      # user.set_temporary_password!

      # @todo add mailers

      @result = t('controller.v1.message.success')
      render('v1/result')

    # can't find user in database
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', @json[:email])
    end

    ##
    #
    ##
    def change_password
    end

    ##
    # Log a user in with their password and email
    #
    # Set a session_token for the user as a cookie
    ##
    def login
      user = User.find_by_email!(@json[:email])
      user.authenticate!(@json[:password])
      user.create_session_token!

      cookies.signed[:session] = {
        value: user.session_token.token,
        expires: user.session_token.expires,
        # @todo set this to true
        secure: false,
        httponly: true
      }

      @result = t('controller.v1.message.success')
      render('v1/result')

    # can't find user in database
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', @json[:email])

    # couldn't authenticate user
    rescue Exceptions::UserAuthenticationError => e
      raise Exceptions::V1ApiError, e.message
    end

    ##
    # Log a user out
    #
    # Deletes the session_token cookie and invalidates it's value in the database
    ##
    def logout
      user = user_from_session!
      user.session_token.disable!
    rescue Exceptions::V1ApiInvalidSessionError
      # silently fail if the session token isn't valid
      # to avoid people being able to guess session ids based on error responses
      nil
    ensure
      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    private

    ##
    #
    ##
    def user_from_session!
      session = cookies.signed[:session_token]
      return User.find_by_session_token!(session)
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiInvalidSessionError, e.message
    end
  end
end
