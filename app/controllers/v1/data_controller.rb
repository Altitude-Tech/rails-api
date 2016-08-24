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
      # order <http://stackoverflow.com/questions/9197649/rails-sort-by-join-table-data>
    rescue ActiveRecord::RecordNotFound => exc
      to_raise = Exceptions::V1ApiNotFoundError.new(exc, 'device_id', params[:device_id])
      to_raise.set_backtrace(exc.backtrace)

      raise to_raise
    end

    ##
    # Creates a new data entry.
    ##
    def create
      #begin
      #  check_keys(@json, CREATE_KEYS)

      #  @json[:data].each do |data|
      #    check_keys(data, CREATE_DATA_KEYS)
      #  end
      #rescue KeyError => e
      #  render_error(e) && return
      #end

      #insert_to_db
    end

    private

    ##
    #
    ##
    def get_device(device_id)
      device_data = { device_id: device_id }

      begin
        return Device.find_by!(device_data)
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordNotFound, t(:data_invalid_device, device: device_id)
      end
    end

    ##
    # This has to happen before creation, otherwise rails will silently
    # convert the integer to nil and then claims validation failed.
    #
    # See <http://stackoverflow.com/a/29941161>
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

    ##
    #
    ##
    def make_base_data
      device = get_device(@json[:did])

      data = @json.select do |k, _|
        [:log_time, :temperature, :humidity, :pressure].include?(k)
      end

      data[:device_id] = device.id
      data[:log_time] = format_log_time(data[:log_time])

      return data
    end

    ##
    # Attempt to create an entry for data and handle any thrown errors
    #
    # @todo remove outer transaction when device isn't created if missing
    #       and move it to `insert_each`
    ##
    def insert_to_db
      Datum.transaction do
        base_data = make_base_data
        sensor_data = @json[:data]

        insert_each(sensor_data, base_data)
      end
    rescue ArgumentError, ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      render_error(e.message)
    rescue ActiveRecord::StatementInvalid
      # should be invalid log time
      # although other errors could occur
      render_error(t(:data_invalid_time))
    else
      begin
        render_success('Data successfully inserted.')
      rescue TypeError => e
        render_error(e.message)
      end
    end

    ##
    # Attempt to insert each entry into the database
    ##
    def insert_each(sensor_data, base_data)
      raise ArgumentError, '"data" value must be an array.' unless
        sensor_data.is_a?(Array)

      sensor_data.each do |d|
        data = d.merge(base_data)

        Datum.create!(data)
      end
    end
  end
end
