##
#
##
module V1
  module Admin
    class DevicesController < V1::ApiController
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
