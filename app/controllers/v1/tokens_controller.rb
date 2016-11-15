module V1
  ##
  #
  ##
  class TokensController < ApiController
    ##
    # Generate a new token
    ##
    def create
      @token = Token.create! expires: 10.minutes.from_now
    end
  end
end
