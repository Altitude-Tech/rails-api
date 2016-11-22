module V1
  ##
  #
  ##
  class UsersController < V1::ApiController
    ##
    # Filters
    ##
    before_action :authenticate_user, only: [:show, :update, :reset_password]

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
    #
    # If a session already exists, it will be invalidated and replaced.
    ##
    def login
      user = User.find_by_email! @body[:email]
      token = user.authenticate! @body[:password]
      session_token token

      @result = 'success'
      render 'v1/result'
    rescue ActiveRecord::RecordNotFound
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
    end

    ##
    # Update a user's details
    ##
    def update
      @user.update_details! @body
    rescue Record::UpdateError => exc
      raise Api::UpdateError, exc.message
    rescue ActiveRecord::RecordInvalid => exc
      raise Api::InvalidUpdateError, exc
    end

    ##
    #
    ##
    def reset_password
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
        # secure: ENV['RAILS_ENV'] == 'production' ? true : false
        secure: false
      }

      cookies.signed[:session] = data
    end
  end
end
