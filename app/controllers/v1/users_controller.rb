module V1
  class UsersController < V1::ApiController
    ##
    # Filters
    ##
    before_action :authenticate_user, only: [:show]

    ##
    # Create a new user.
    ##
    def create
      User.create!(@body)

      @result = 'success'
      render 'v1/result'
    rescue ActiveRecord::RecordInvalid => exc
      raise Api::InvalidCreateError, exc
    end

    ##
    # Log a user in using their email and password.
    #
    # Creates and sets a session token as a cookie if successful.
    ##
    def login
      user = User.find_by_email! @body[:email]
      token = user.authenticate! @body[:password]
      session_token token

      @result = 'success'
      render 'v1/result'
    rescue ActiveRecord::RecordNotFound => exc
      raise Api::NotFoundError, 'email'
    rescue Record::UserAuthError => exc
      raise Api::LoginAuthError, exc
    end

    ##
    # Log a user out.
    #
    # Attempts to delete the user's session token cookie if it exists
    # and disable the session token in the database.
    ##
    def logout
      delete_session_token

      @result = 'success'
      render 'v1/result'
    end

    ##
    # Get a user's details.
    ##
    def show
      user_from_email = User.find_by_email! params[:email]

      unless @user == user_from_email
        msg = 'Not authorised.'
        raise Api::AuthError, msg
      end
    end

    private

    ##
    # Set a session token as a cookie.
    ##
    def session_token(token)
      # invalidate any existing token first
      delete_session_token
      data = {
        value: token.token,
        expires: token.expires,
        httponly: true,
        # TODO: set this to true in production
        secure: ENV['RAILS_ENV'] == 'production' ? false : false
      }

      cookies.signed[:session] = data
    end
  end
end
