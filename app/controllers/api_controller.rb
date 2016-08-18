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
  #
  ##
  def make_base_data
    device = get_device(@json[:did], @json[:dype])

    data = @json.select do |k, _|
      [:log_time, :temperature, :humidity, :pressure].include?(k)
    end

    data[:device_id] = device.id
  end

  ##
  # Attempt to create an entry for data
  ##
  def insert_to_db
    # @todo remove outer transaction when device isn't created if missing
    Device.transaction do
      Datum.transaction do
        base_data = make_base_data
        sensor_data = @json[:data]

        if sensor_data.is_a?(Array)
          sensor_data.each do |d|
            insert_each(d, base_data.deep_dup)
          end
        else
          insert_each(sensor_data, base_data)
        end
      end
    end
  end

  ##
  #
  ##
  def insert_each(data, parent_data)
    data = data.map { |k, v| [k.downcase, v] }.to_h
    data = data.symbolize_keys
    data = data.merge(parent_data)

    logger.debug('data:')
    logger.debug(data)

    Datum.create!(**data)
  end
end
