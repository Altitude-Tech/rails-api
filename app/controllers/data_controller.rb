module V1
  class DataApiController < ApiController
    ##
    # Create a new data point for a device.
    #
    # Should only be used by devices reporting their data.
    ##
    def create
    end

    ##
    # Get a set of data associated with a specific device.
    #
    # Requires that the user accessing the data has permission to view the device.
    ##
    def index
    end

    ##
    # Get a single data point for a specific device.
    #
    # Requires that the user accessing the data has permission to view the device.
    ##
    def show
    end
  end
end
