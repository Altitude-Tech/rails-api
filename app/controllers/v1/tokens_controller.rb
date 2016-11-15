module V1
  ##
  #
  ##
  class TokensController < ApiController
    ##
    # Generate a new token
    ##
    def create
      @token = Token.csrf!
    end
  end
end
