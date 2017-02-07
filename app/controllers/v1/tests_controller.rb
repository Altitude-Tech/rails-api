module V1
  ##
  # Controller used exclusively for testing functionality
  # that would either never be triggered in normal usage
  # or is not specific to a single controller
  ##
  class TestsController < ApiController
    before_action :authenticate_user, only: [:create]

    ##
    #
    ##
    def create
      @result = 'success'
      render 'v1/result'
    end

    ##
    #
    ##
    def unhandled_error
      raise StandardError, 'test unhandled error'
    end
  end
end
