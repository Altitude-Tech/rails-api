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
        Datum.transaction do
          @data = convert_raw_data
        end
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
    # Helper method to insert data into the database.
    ##
    def convert_raw_data
      base_data = @body.except(:data)
      data = []

      @body[:data].each do |d|
        d = d.merge(base_data)

        raw_datum = RawDatum.create! d
        datum = raw_datum.to_datum!

        data.concat(datum)
      end

      return data
    end
  end
end
