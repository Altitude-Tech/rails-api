require 'api_exceptions'
require 'record_exceptions'

##
#
##
module V1
  class ApiController < BaseApiController
    ##
    # Filters
    ##
    before_action :set_json
    before_action do
      methods = %w(POST PUT PATCH)
      parse_body if methods.include? request.request_method
    end

    ##
    # Error handlers
    ##
    rescue_from Api::Error, with: :handle_api_error

    protected

    ##
    # Attempt to authenticate a user using their session token cookie
    ##
    def authenticate_user
      error_msg = 'Not authorised.'
      raise Api::AuthError, error_msg unless cookies.key? :session

      session = cookies.signed[:session]

      begin
        @user = User.find_by_session_token! session
      rescue ActiveRecord::RecordNotFound
        raise ApiAuthError, error_msg
      end
    end

    ##
    # Delete the session token cookie if it exists
    ##
    def delete_session_token
      # disable the token in the database
      if cookies.key? :session
        session = cookies.signed[:session]

        begin
          user = User.find_by_session_token! session
          user.reset_session_token!
        rescue ActiveRecord::RecordNotFound
          # silently fail in case the session value was manipulated
          nil
        end
      end

      cookies.delete(:session)
    end

    ##
    # For handling expected exceptions thrown by the Api
    ##
    def handle_api_error(exc)
      render_error exc.code, exc.message, :bad_request
    end

    ##
    # Render an error.
    ##
    def render_error(code, message, status)
      @error = {
        error: code,
        message: message,
        status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      }

      render 'v1/error', status: status
    end

    private

    ##
    # Set the request format to JSON.
    ##
    def set_json
      request.format = :json
    end

    ##
    # Parse the request body from JSON to a hash.
    ##
    def parse_body
      body = request.body.read

      if body.blank?
        @body = {}
        return
      end

      @body = normalise_keys JSON.parse(body)
    end

    ##
    # Normalise keys in a hash.
    #
    # Used to normalise keys in JSON request body.
    ##
    def normalise_keys(hash)
      return hash unless hash.is_a? Hash

      ret = {}

      hash.each do |k, v|
        k = k.downcase.parameterize(separator: '_').to_sym

        if v.is_a? Hash
          v = normalise_keys v
        end

        if v.is_a? Array
          v.map! { |item|
            normalise_keys item
          }
        end

        ret[k] = v
      end

      return ret
    end
  end
end
