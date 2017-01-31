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
      # remove token from request body
      @body.delete(:token)
      # replace identity hash with actual device_id
      @body.delete(:identity)
      @body[:device_id] = @device.id

      RawDatum.create! @body

      @result = 'success'
      render 'v1/result'
    rescue ActiveRecord::RecordInvalid => exc
      raise Api::InvalidCreateError, exc
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
    rescue ActiveRecord::RecordNotFound
      raise Api::NotFoundError, 'identity'
    end

    private

    ##
    # Helper method for authenticating a device with it's token.
    ##
    def authenticate_device
      @device = Device.find_by_identity! @body[:identity]
      @device.authenticate! @body[:token]
    rescue ActiveRecord::RecordNotFound
      raise Api::NotFoundError, 'identity'
    rescue Record::DeviceAuthError => exc
      raise Api::DeviceAuthError, exc.message
    end
  end
end
