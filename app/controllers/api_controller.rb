##
#
##
class ApiController < BaseApiController
  ##
  #
  ##
  KEYS = [:did, :dype, :log_time, :temperature, :humidity,
          :pressure, :data].freeze
  DATA_KEYS = [:sensor_type, :sensor_error, :sensor_data].freeze

  ##
  #
  ##
  def index
    if params.key? :help
      render plain: 'help'
      return
    end

    render json: params
  end

  ##
  # Creates a new entry in data.
  #
  # Also creates a new entry in devices if not found already.
  ##
  def create
    @json = normalize_keys(@json)

    begin
      check_keys(@json, KEYS)

      if @json[:data].is_a?(Array)
        @json[:data].each do |data|
          check_keys(data, DATA_KEYS)
        end
      else
        check_keys(@json[:data], DATA_KEYS)
      end
    rescue KeyError => e
      render_error(e) && return
    end

    insert_to_db
  end

  private

  ##
  # Normalise keys to lowercase symbols
  ##
  def normalize_keys(hash)
    ret = {}

    hash.each do |k, v|
      k = k.downcase.parameterize(separator: '_').to_sym

      if v.is_a?(Array)
        new_v = []

        v.each do |el|
          new_v.append(normalize_keys(el))
        end

        v = new_v
      end

      ret[k] = v
    end

    # rubocop:disable Style/RedundantReturn
    return ret
    # rubocop:enable Style/RedundantReturn
  end

  ##
  # Check required keys exist
  ##
  def check_keys(hash, keys)
    keys.each do |key|
      raise KeyError, t(:data_missing_key, key: key) unless hash.key?(key)
    end
  end

  ##
  #
  ##
  def get_device(device_id, device_type)
    device_data = { device_id: device_id, device_type: device_type }

    begin
      Device.find_by!(device_data)
    rescue ActiveRecord::RecordNotFound
      Device.create!(device_data)
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
    Time.at(time).to_s(:db)
  end

  ##
  #
  ##
  def make_base_data
    device = get_device(@json[:did], @json[:dype])

    data = @json.select do |k, _|
      [:log_time, :temperature, :humidity, :pressure].include?(k)
    end

    data[:device_id] = device.id
    data[:log_time] = format_log_time(data[:log_time])

    # rubocop:disable Style/RedundantReturn
    return data
    # rubocop:enable Style/RedundantReturn
  end

  ##
  # Attempt to create an entry for data
  #
  # @todo remove outer transaction when device isn't created if missing
  ##
  def insert_to_db
    Device.transaction do
      Datum.transaction do
        base_data = make_base_data
        sensor_data = @json[:data]

        if sensor_data.is_a?(Array)
          sensor_data.each do |d|
            insert_each(d, base_data.deep_dup)
          end
        else
          render_error('"data" value must be an array.')
        end
      end
    end
  rescue ArgumentError => e
    render_error(e.message)
  rescue ActiveRecord::RecordInvalid => e
    render_error(e.message)
  rescue ActiveRecord::StatementInvalid
    render_error(t(:data_invalid_time))
  else
    success = { success: 'Data successfully inserted.' }
    render(json: success.to_json)
  end

  ##
  #
  ##
  def insert_each(sensor_data, parent_data)
    data = sensor_data.merge(parent_data)
    logger.debug('data: ' + data.to_s)

    Datum.create!(data)
  end
end
