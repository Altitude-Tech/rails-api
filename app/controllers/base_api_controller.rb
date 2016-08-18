##
# Base api controller
##
class BaseApiController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :parse_request, :check_ip, only: :create

  protected

  ##
  # Render an error message as json
  ##
  def render_error(msg)
    error = { error: msg }
    render(json: error.to_json, status: :bad_request)
  end

  private

  ##
  # Attempt to parse the request body
  ##
  def parse_request
    body = request.body.read
    render_error(t(:base_api_missing_body)) && return if body.blank?

    logger.debug(body)

    begin
      @json = JSON.parse(body)
    rescue JSON::ParserError => e
      render_error(t(:base_api_json_parse_error, msg: e.message)) && return
    end
  end

  ##
  # Check request IP address matches a whitelisted IP
  #
  # @todo implement this
  ##
  def check_ip
    # @todo disable in development as well
    logger.debug(request.remote_ip) unless Rails.env.test?
  end
end
