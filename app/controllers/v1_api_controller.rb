##
# Application controller
##
class V1ApiController < ApplicationController
  before_action :parse_request, only: [:create, :update]
  before_action :set_json

  protected

  ##
  # Validate an argument is an integer and within defined limits
  ##
  def validate_int(num, min, max)
    begin
      num = Integer(num)
    # for catching nil
    rescue TypeError => e
      raise ArgumentError, e
    end

    not_between = (num < min) || (num > max)

    raise ArgumentError, t(:v1_api_int_outside_limits) if not_between

    return num
  end

  ##
  # Check required keys exist
  ##
  def check_keys(hash, keys)
    keys.each do |key|
      raise KeyError, t(:v1_api_missing_key, key: key) unless hash.key?(key)
    end
  end

  ##
  # Render an error message as json
  ##
  def render_error(msg)
    error = { error: msg }
    render(json: error, status: :bad_request)
  end

  ##
  # Render a success message as json
  ##
  def render_success(msg)
    success = { success: msg }
    render(json: success)
  end

  ##
  # Check request IP address matches a whitelisted IP
  #
  # @todo implement this
  ##
  def check_ip
    # @todo disable in development as well
    logger.debug('IP: ' + request.remote_ip.to_s) unless Rails.env.test?
  end

  ##
  # Sets format for view templates
  ##
  def set_json
    request.format = :json
  end

  private

  ##
  # Attempt to parse the request body
  ##
  def parse_request
    body = request.body.read
    render_error(t(:v1_api_missing_body)) && return if body.blank?

    begin
      @json = JSON.parse(body)
      @json = normalize_keys(@json)
    rescue JSON::ParserError => e
      render_error(t(:v1_api_json_parse_error, msg: e.message)) && return
    end
  end

  ##
  # Normalise keys to lowercase symbols
  ##
  def normalize_keys(hash)
    ret = {}

    hash.each do |k, v|
      k = k.is_a?(String) ? k.downcase.parameterize(separator: '_').to_sym : k

      if v.is_a?(Array)
        new_v = []

        v.each do |el|
          new_v.append(el.is_a?(Hash) ? normalize_keys(el) : el)
        end

        v = new_v
      end

      v = normalize_keys(v) if v.is_a?(Hash)

      ret[k] = v
    end

    return ret
  end
end
