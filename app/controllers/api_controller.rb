class ApiController < BaseApiController
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
    begin
      format_log_time
    rescue KeyError, ArgumentError
      # let it be caught below
    end

    begin
      check_for_device
    rescue KeyError => e
      logger.debug(e.message)
      render plain: e.message.to_s, status: :bad_request
      return
    # <http://www.rubydoc.info/docs/rails/4.1.7/ActiveRecord/RecordInvalid>
    rescue ActiveRecord::RecordInvalid => e
      logger.debug(e.message)
      render plain: e.message.to_s, status: :bad_request
      return
    end

    begin
      insert_to_db
    rescue KeyError => e
      render plain: 'Key not found: DATA (Data).', status: :bad_request
      return
    rescue ActiveRecord::RecordInvalid => e
      render plain: e.message.to_s, status: :bad_request
      return
    end

    render plain: 'Data inserted successfully.'
  end

  private
    ##
    # Formats unix time to a format accepted by mysql.
    ##
    def format_log_time
      # use this to catch out any non-integers
      log_time = Integer(@json.fetch('LOG_TIME'))
      # convert unix time to sql datetime format
      @json['LOG_TIME'] = Time.at(log_time).to_s(:db)
    end

    ##
    # Checks to see if the device exists yet and tries to create it if not.
    ##
    def check_for_device
      device_data = {}

      # add these separate into the hash to improve error response
      begin
        device_data[:device_id] = @json.fetch('DID')
      rescue KeyError
        raise KeyError, 'Key not found: DID (Device id).'
      end

      begin
        device_data[:device_type] = @json.fetch('DYPE')
      rescue KeyError
        raise KeyError, 'Key not found: DYPE (Device type).'
      end

      begin
        # check both id and type match
        # to make sure either/both being invalid is caught correctly
        @device = Device.find_by!(**device_data)

      # @todo remove when user table is set up
      rescue ActiveRecord::RecordNotFound
        # attempt to insert instead
        @device = Device.create!(**device_data)
      end
    end

    ##
    # Attempt to create an entry for data
    ##
    def insert_to_db
      data = @json.fetch('DATA')

      parent_data = {
        log_time: @json['LOG_TIME'],
        temperature: @json['TEMPERATURE'],
        humidity: @json['HUMIDITY'],
        pressure: @json['PRESSURE'],
        device_id: @device.id
      }

      if data.kind_of?(Array)
        data.each do |d|
          insert_each(d, parent_data.deep_dup)
        end
      else
        insert_each(data, parent_data)
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
