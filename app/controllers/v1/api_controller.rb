require 'exceptions/api_exceptions'
require 'exceptions/record_exceptions'

module V1
  ##
  #
  ##
  class ApiController < BaseApiController
    ##
    # Filters
    ##
    before_action :set_cors_headers
    before_action :set_json
    before_action do
      methods = %w(POST PUT PATCH)
      parse_body if methods.include? request.request_method
    end

    ##
    # Error handlers
    #
    # List in order of least specific to most specific
    # As it's matched from bottom to top
    ##
    rescue_from StandardError, with: :handle_standard_error
    rescue_from Api::Error, with: :handle_api_error

    ##
    # Handle OPTIONS requests
    #
    # TODO: move to `BaseApiController`?
    ##
    def options
      # TODO: check if this is the correct way to repond to this
      render text: '', content_type: 'text/plain'
    end

    protected

    ##
    # Attempt to authenticate a user using their session token cookie
    ##
    def authenticate_user
      error_msg = 'Not authorised.'
      raise Api::AuthError, error_msg unless cookies.key? :session

      session = cookies.signed[:session]

      @user = User.find_by_session_token! session
    rescue ActiveRecord::RecordNotFound
      raise ApiAuthError, error_msg
    end

    ##
    # Attempt to verify that a CSRF token is present and valid
    ##
    def require_token
      error_msg = 'Not authorised.'
      t = Token.find(@body[:json])

      raise Api::AuthError, error_msg unless t.active?
    rescue ActiveRecord::RecordNotFound
      raise ApiAuthError, error_msg
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
    # For handling expected exceptions thrown by the Api.
    ##
    def handle_api_error(exc)
      render_error exc.code, exc.message, :bad_request, exc.user_message
    end

    ##
    # For handling exceptions not thrown by the Api
    # (essentially unhandled exceptions).
    ##
    def handle_standard_error(exc)
      # TODO: Log/Email about the exception
      Rails.logger.fatal(exc.message)

      msg = 'An unhandled exception occurred.'
      render_error 500, msg, :internal_server_error
    end

    ##
    # Render an error.
    ##
    def render_error(code, message, status, user_message = nil)
      @error = {
        error: code,
        message: message,
        status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      }

      unless user_message.nil?
        @error[:user_message] = user_message
      end

      render 'v1/error', status: status
    end

    private

    ##
    # Constants for CORS headers
    ##
    HEADERS = %w(Origin X-Requested-With Content-Type Accept Authorization).freeze
    METHODS = %w(GET OPTIONS PATCH POST PUT).freeze

    ##
    # Set CORS headers so the API is accessible from browsers
    ##
    def set_cors_headers
      # set the allow-origin header to the exact origin
      # otherwise the credentials (cookies) won't be recieved correctly
      headers['Access-Control-Allow-Origin'] = request.headers['origin']
      headers['Access-Control-Allow-Headers'] = HEADERS.join(', ')
      headers['Access-Control-Allow-Methods'] = METHODS.join(', ')
      headers['Access-Control-Allow-Credentials'] = true
    end

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
    rescue JSON::ParserError => e
      raise Api::JsonParserError, e.message
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
          v.map! do |item|
            normalise_keys item
          end
        end

        ret[k] = v
      end

      return ret
    end
  end
end
