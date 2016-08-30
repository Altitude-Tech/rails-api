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
    ##
    # Register a new device
    ##
    def create
      Device.create!(@json)

      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    ##
    # Get a list of devices
    ##
    def index
      limit = extract_int_param('limit', 10, 1, 500, 'devices')
      start = extract_int_param('start', 1, 1, Float::INFINITY, 'devices')

      @devices = Device.where('id >= ?', start).order('id').limit(limit)

      raise Exceptions::V1ApiError, t('controller.v1_devices.error.no_more') unless @devices.any?
    end

    ##
    # Get details about a specific device
    ##
    def show
      # look up by device_id rather than id (primary key in the database)
      # as it's the indentification people are more likely to have
      @device = Device.find_by!(device_id: params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'id', params[:id])
    end
  end
end
