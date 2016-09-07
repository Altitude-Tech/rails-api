##
# Application controller
##

require 'exceptions'
require 'v1/error_handler'
require 'v1/param_handler'

##
#
##
class V1ApiController < ApplicationController
  ##
  # Pre-process incoming requests to the API
  ##
  before_action(:set_json)
  before_action do
    methods = %w(POST PUT PATCH)
    parse_request if methods.include?(request.request_method)
  end

  ##
  # Error handling functions
  ##
  rescue_from(StandardError, with: :standard_error)
  rescue_from(Exceptions::V1ApiError, with: :normal_error)
  rescue_from(Exceptions::V1ApiNotFoundError, with: :not_found_error)
  rescue_from(JSON::ParserError, with: :json_parser_error)
  rescue_from(ActiveModel::UnknownAttributeError, with: :unknown_attr_error)
  rescue_from(ActiveRecord::RecordInvalid, with: :record_invalid_error)

  include ErrorHandler
  include ParamHandler

  protected

  ##
  # Check request IP address matches a whitelisted IP
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

    if body.blank?
      @json = {}
      return
    end

    @json = JSON.parse(body)
    @json = normalize_keys(@json)
  end

  ##
  # Normalise keys to lowercase symbols
  #
  # Does not handle arrays within arrays
  ##
  def normalize_keys(hash)
    ret = {}

    hash.each do |k, v|
      # don't modify symbols
      k = k.is_a?(String) ? k.downcase.parameterize(separator: '_').to_sym : k

      if v.is_a?(Array)
        # make a new array for the values
        # as it didn;t work properly without it
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
