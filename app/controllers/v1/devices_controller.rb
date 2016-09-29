module V1
  ##
  #
  ##
  class DevicesController < V1::ApiController
    before_action :authenticate_user

    ##
    # Register a new device
    ##
    def register
      @device = Device.find_by_identity! @body[:identity]
      @device.register! @user.group
    rescue ActiveRecord::RecordNotFound
      raise Api::NotFoundError, 'identity'
    rescue Record::DeviceRegistrationError => exc
      raise Api::DeviceRegistrationError, exc.message
    end
  end
end
