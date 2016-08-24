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
  before_action :parse_request, only: [:create, :update]
  before_action :set_json

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

    if body.blank?
      msg = I18n.t('controller.v1.error.missing_request_body')
      raise Exceptions::V1ApiError, msg
    end

    @json = JSON.parse(body)
    @json = normalize_keys(@json)
  end

  ##
  # Normalise keys to lowercase symbols
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

        # @todo handle nested arrays?
        v = new_v
      end

      v = normalize_keys(v) if v.is_a?(Hash)

      ret[k] = v
    end

    return ret
  end
end
