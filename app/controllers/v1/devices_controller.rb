##
# Devices api controller
##
module V1
  ##
  #
  ##
  class DevicesController < V1ApiController
    rescue_from(ActiveModel::UnknownAttributeError, with: render_error)
    rescue_from(ArgumentError, with: render_error)
    rescue_from ActiveRecord::RecordInvalid, with: render_error

    def create
      Device.create!(@json)

      @result = t(:v1_api_success)
      render('v1/result')
    end

    ##
    #
    ##
    def index
      limit = extract_int_param('limit', 10, 1, 500)
      start = extract_int_param('start', 1, 1, Float::INFINITY)

      @devices = Device.where('id >= ?', start).order('id').limit(limit)

      raise ArgumentError, t(:devices_no_more) unless @devices.any?
    rescue ArgumentError => e
      @error = e.message
      render('v1/error', status: :bad_request) && return
    end

    ##
    #
    ##
    def show
      # look up by device_id rather than id (primary key in the database)
      # as it's the indentification people are more likely to have
      @device = Device.find_by!(device_id: params[:id])
    rescue ActiveRecord::RecordNotFound
      @error = t(:devices_not_found)
      render('v1/error', status: :bad_request) && return
    end

    private

    ##
    #
    ##
    def extract_int_param(param, default, min, max)
      val = params[param] || default
      validate_int(val, min, max)
    rescue ArgumentError
      msg = "devices_error_#{param}"
      msg = param == 'limit' ? t(msg, max: max) : t(msg)

      raise ArgumentError, msg
    end


  end
end
