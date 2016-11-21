module V1
  module Staff
    ##
    #
    ##
    class DevicesController < V1::StaffController
      ##
      # Create a new device.
      ##
      def create
        @device = Device.create! @body
      rescue ActiveRecord::RecordInvalid => exc
        raise Api::InvalidCreateError, exc
      end
    end
  end
end
