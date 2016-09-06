##
#
#
# @todo add a way of undoing update/change_password
#       investigate <https://github.com/collectiveidea/audited>
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
    # Get a list of users
    ##
    def index
      limit = extract_int_param('limit', 10, 1, 500, 'users')
      start = extract_int_param('start', 1, 1, Float::INFINITY, 'users')

      @users = User.where('id >= ?', start).order('id').limit(limit)

      raise Exceptions::V1ApiError, t('controller.v1_users.error.no_more') unless @users.any?
    end

    ##
    # Get a specific user's details
    ##
    def show
      @user = User.find_by_email!(params[:email])
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', params[:email])
    end

    ##
    # Update a user's name or email
    ##
    def update_details
      user = User.find_by_email!(@json[:email])
      user.update_details!(@json)

      @result = t('controller.v1.message.success')
      render('v1/result')
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', @json[:email])
    rescue ArgumentError => e
      raise Exceptions::V1ApiError, e.message
    rescue ActiveRecord::RecordInvalid
      raise Exceptions::V1ApiRecordInvalid, 'new_email'
    end

    ##
    # Reset a user's password
    ##
    def reset_password
      user = User.find_by_email!(@json[:email])
      user.change_password!(@json[:password], @json[:new_password])

      @result = t('controller.v1.message.success')
      render('v1/result')
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', @json[:email])
    rescue ArgumentError => e
      raise Exceptions::V1ApiError, e.message
    rescue ActiveRecord::RecordInvalid
      raise Exceptions::V1ApiRecordInvalid, 'new_password'
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
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'email', @json[:email])
    rescue ArgumentError => e
      raise Exceptions::V1ApiError, e.message
    end

    ##
    # Log a user out
    #
    # Deletes the session_token cookie and invalidates it's value in the database
    ##
    def logout
      user = User.find_by_session_token!(@json[:session_token])
      user.session_token.disable!
    rescue ActiveRecord::RecordNotFound
      # silently fail if the session token isn't valid
      # to avoid people being able to guess session ids based on error responses
      nil
    ensure
      @result = t('controller.v1.message.success')
      render('v1/result')
    end
  end
end
