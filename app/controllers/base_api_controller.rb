class BaseApiController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :parse_request, :check_ip, only: :create

  private
    def parse_request
      body = request.body.read

      if body.blank?
        msg = 'Missing request body.'
        to_return = {error: msg}

        render json: to_return.to_json, status: :bad_request
        return
      end

      logger.debug(request.body.read)

      begin
        @json = JSON.parse(request.body.read)
      rescue JSON::ParserError => e
        msg = "There was a problem in the JSON you submitted: #{e.message}"
        to_return = {error: msg}

        render json: to_return.to_json, status: :bad_request
      end


      logger.debug('parse_request')
      logger.debug(@json)
      logger.debug(params)
      logger.debug(params.to_h)
    end

    def check_ip
      # @todo disable in development as well
      if !Rails.env.test?
        # @todo stop if this is not the expected IP
        logger.debug(request.remote_ip)
      end
    end
end
