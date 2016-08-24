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
  class DataController < V1ApiController
    before_action :set_json

    rescue_from(Exceptions::V1ApiNotFoundError, with: :not_found_error)

    ##
    #
    ##
    def show
      device = Device.find_by!(device_id: params[:device_id])
      @data = device.datum
      # @todo order?
      # <http://stackoverflow.com/questions/9197649/rails-sort-by-join-table-data>
    rescue ActiveRecord::RecordNotFound => e
      raise Exceptions::V1ApiNotFoundError.new(e, 'device_id', params[:device_id])
    end

    ##
    # Creates a new data entry.
    ##
    def create
      data = get_data(@json)

      Datum.transaction do
        data.each do |d|
          Datum.create!(d)
        end
      end
    rescue NoMethodError
      msg = t('controller.v1.error.invalid_value', key: 'data')
      raise Exceptions::V1ApiError, msg
    else
      @result = t('controller.v1.message.success')
      render('v1/result')
    end

    private

    ##
    #
    ##
    def get_data(raw_data)
      base_data_keys = %i(log_time pressure humidity temperature)
      sensor_data_keys = %i(sensor_error sensor_data sensor_type)
      ret = []

      # device_id as a hash is exposed to end users
      # not the internal id in the database
      device = get_device(raw_data[:device_id])

      base_data = raw_data.select do |k, _|
        base_data_keys.include?(k)
      end

      base_data[:device_id] = device.id

      raw_data[:data].each do |d|
        data = d.select do |k, _|
          sensor_data_keys.include?(k)
        end

        ret.append(data.merge(base_data))
      end

      return ret
    end

    ##
    # @todo handle this with V1ApiNotFoundError
    ##
    def get_device(device_id)
      device_data = { device_id: device_id }
      return Device.find_by!(device_data)
    rescue ActiveRecord::RecordNotFound
      msg = t('controller.v1.error.invalid_value', key: 'device_id')
      raise Exceptions::V1ApiError, msg
    end

    ##
    # This has to happen before creation, otherwise rails will silently
    # convert the integer to nil and then claims validation failed.
    #
    # See <http://stackoverflow.com/a/29941161>
    #
    # @todo report bug / make a workaround?
    #
    # @todo add min & max time here
    ##
    def format_log_time(time)
      # catch out any non-integers
      time = Integer(time)
    rescue TypeError, ArgumentError
      raise ArgumentError, t(:data_invalid_time)
    else
      # convert unix time to sql datetime format
      return Time.at(time).utc.to_s(:db)
    end
  end
end
