##
# Devices api controller
##
module V1
  ##
  #
  ##
  class DevicesController < V1ApiController
    ##
    #
    ##
    CREATE_KEYS = [:device_id, :device_type].freeze

    ##
    #
    ##
    def create
      begin
        check_keys(@json, CREATE_KEYS)
      rescue KeyError => e
        render_error(e.message) && return
      end

      data = @json.select do |k, _|
        CREATE_KEYS.include?(k)
      end

      begin
        Device.create!(data)
      rescue ActiveRecord::RecordInvalid => e
        @error = e.message
        render('v1/error', status: :bad_request) && return
      end

      @result = t(:v1_api_success)
      render('v1/result')
    end

    ##
    #
    ##
    def index
      limit = extract_int_param('limit', 10, 1, 500)
      start = extract_int_param('start', 1, 1, Float::INFINITY)

      return if limit == false || start == false

      @devices = Device.where('id >= ?', start).order('id').limit(limit)

      unless @devices.any?
        @error = t(:devices_no_more)
        render('v1/error', status: :bad_request) && return
      end
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

      begin
        validate_int(val, min, max)
      rescue ArgumentError
        msg = "devices_error_#{param}"
        @error = param == 'limit' ? t(msg, max: max) : t(msg)

        render('v1/error', status: :bad_request)
        return false
      end
    end
  end
end
