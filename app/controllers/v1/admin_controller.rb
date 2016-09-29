module V1
  ##
  #
  ##
  class AdminController < V1ApiController
    before_action :authenticate_admin

    protected

    ##
    # Attempt to authenticate an admin using their session token cookie
    ##
    def authenticate_admin
      # TODO: Implement
    end
  end
end
