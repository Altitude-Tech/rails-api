require 'sensly/sensors/pm_sensor'
require 'sensly/sensors/mq2_sensor'
require 'sensly/sensors/mq7_sensor'
require 'sensly/sensors/mq135_sensor'
require 'sensly/sensly'

module V1
  ##
  #
  ##
  class DataController < ApiController
    before_action :authenticate_device, only: [:create]
    before_action :authenticate_user, only: [:show]

    ##
    # Create a new set of data associated with a particular device.
    ##
    def create
      # replace identity hash with actual device_id
      @body.delete(:identity)
      @body[:device_id] = @device.id

      RawDatum.transaction do
        @gas_data = convert_raw_data
      end

      Datum.transaction do
        store_data
      end
    rescue ActiveRecord::RecordInvalid => exc
      raise Api::InvalidCreateError, exc
    rescue ActiveRecord::RecordNotUnique
      msg = 'Duplicate data submitted.'
      raise Api::DuplicateDataError, msg
    end

    ##
    # Get data associated with a specific device.
    ##
    def show
      # mask device not found with not authorised
      begin
        @device = Device.find_by_identity! params[:identity]
      rescue ActiveRecord::RecordNotFound
        msg = 'Not authorised.'
        raise Api::AuthError, msg
      end

      unless !@user.group.nil? && @user.group == @device.group
        msg = 'Not authorised.'
        raise Api::AuthError, msg
      end

      @data = @device.raw_datum
    end

    private

    ##
    # Helper method for authenticating a device with it's token.
    ##
    def authenticate_device
      @device = Device.find_by_identity! @body[:identity]
      @device.authenticate! @body[:token]

      # remove token now that we're done with it
      @body.delete(:token)
    rescue ActiveRecord::RecordNotFound
      raise Api::NotFoundError, 'identity'
    rescue Record::DeviceAuthError => exc
      raise Api::DeviceAuthError, exc.message
    end

    ##
    # Helper method to insert raw data into the database.
    ##
    def convert_raw_data
      base_data = @body.except(:data)
      data = {}

      @body[:data].each do |d|
        d = d.merge(base_data)
        datum = RawDatum.create! d

        gases = convert_data d

        unless gases.empty?
          data[datum.sensor_name] = gases
        end
      end

      return merge_gas_data data
    end

    ##
    # Merge ppm values for gases together if they appear the data for multiple sensors.
    ##
    def merge_gas_data(data)
      merged_data = {}

      data.values.each do |v|
        v.each do |gas, data|
          unless merged_data.key? gas
            merged_data[gas] = {}
          end

          unless data[:ppm].nil?
            if merged_data[gas][:ppm].nil?
              merged_data[gas][:ppm] = []
            end

            merged_data[gas][:ppm].push(data[:ppm])
          end

          unless data[:ugm3].nil?
            if merged_data[gas][:ugm3].nil?
              merged_data[gas][:ugm3] = []
            end

            merged_data[gas][:ugm3].push(data[:ugm3])
          end
        end
      end

      merged_data.each do |k, data|
        unless data[:ppm].nil?
          merged_data[k][:ppm] = (data[:ppm].sum / data[:ppm].size).round(4)
        end

        unless data[:ugm3].nil?
          merged_data[k][:ugm3] = (data[:ugm3].sum / data[:ugm3].size).round(4)
        end
      end

      return merged_data
    end

    ##
    #
    ##
    def convert_data(data)
      values = [
        data[:sensor_data],
        data[:sensor_r0],
        data[:temperature],
        data[:humidity]
      ]
      gases = {}

      sensor =
        case data[:sensor_type]
        when RawDatum::SENSOR_MQ2_HASH
          Sensly::MQ2Sensor.new(*values)

        when RawDatum::SENSOR_MQ7_HASH
          Sensly::MQ7Sensor.new(*values)

        when RawDatum::SENSOR_MQ135_HASH
          Sensly::MQ135Sensor.new(*values)

        when RawDatum::SENSOR_PM_HASH
          Sensly::PMSensor.new(data[:sensor_data])

        else
          # shouldn't be possible as it should have been caught during
          # validation by RawDatum
          raise Sensly::UnknownError, 'Unknown sensor type'
        end

      sensor.gases do |gas|
        data = {}

        if gas.include? :ppm
          data[:ppm] = gas[:ppm].round(4)
        end

        if gas.include? :ugm3
          data[:ugm3] = gas[:ugm3].round(4)
        end

        gases[gas[:name]] = data
      end

      return gases
    end

    ##
    #
    ##
    def store_data
      base_data = @body.select { |k, _| [:device_id, :log_time].include? k }
      @data = []

      @gas_data.each do |name, val|
        data = {}

        data[:gas] = Sensly::gas_from_name(name)

        unless val[:ppm].nil?
          data[:conc_ppm] = val[:ppm]
        end

        unless val[:ugm3].nil?
          data[:conc_ugm3] = val[:ugm3]
        end

        data = data.merge(base_data)
        d = Datum.create! data
        @data.push(d)
      end
    end
  end
end
