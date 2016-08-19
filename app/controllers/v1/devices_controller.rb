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
    def index
      limit = extract_int_param('limit', 10, 1, 500)
      start = extract_int_param('start', 1, 1, Float::INFINITY)

      return if limit == false || start == false

      @devices = Device.where('id >= ?', start).order('id').limit(limit)

      render_error(t(:devices_no_more)) unless @devices.any?
    end

    ##
    #
    ##
    def show
      # look up by device_id rather than id (primary key in the database)
      # as it's the indentification people are more likely to have
      @device = Device.find_by!(device_id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error(t(:devices_not_found))
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
        msg = param == 'limit' ? t(msg, max: max) : t(msg)

        render_error(msg)
        return false
      end
    end
  end
end
