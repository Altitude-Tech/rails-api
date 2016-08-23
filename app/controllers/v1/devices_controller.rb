##
#
##

require 'exceptions'

##
#
##
module V1
  ##
  #
  ##
  class DevicesController < V1ApiController
    rescue_from(ActiveModel::UnknownAttributeError, with: :unknown_attr_error)
    rescue_from(ActiveRecord::RecordInvalid, with: :record_invalid_error)

    ##
    #
    ##
    def create
      Device.create!(@json)

      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    ##
    #
    ##
    def index
      limit = extract_int_param('limit', 10, 1, 500)
      start = extract_int_param('start', 1, 1, Float::INFINITY)

      @devices = Device.where('id >= ?', start).order('id').limit(limit)

      raise Exceptions::V1ApiError, t(:devices_no_more) unless @devices.any?
    end

    ##
    #
    ##
    def show
      # look up by device_id rather than id (primary key in the database)
      # as it's the indentification people are more likely to have
      @device = Device.find_by!(device_id: params[:id])
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::V1ApiError, t(:devices_not_found)
    end

    private

    ##
    #
    ##
    def extract_int_param(param, default, min, max)
      val = params[param] || default
      validate_int(val, min, max)
    rescue ArgumentError, Exceptions::V1ApiError
      msg_key = "controller.v1_devices.error.#{param}"
      msg = param == 'limit' ? t(msg_key, max: max) : t(msg_key)

      raise Exceptions::V1ApiError, msg
    end
  end
end
