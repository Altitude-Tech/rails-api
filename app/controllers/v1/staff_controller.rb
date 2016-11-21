module V1
  ##
  #
  ##
  class StaffController < V1::ApiController
    before_action :authenticate_staff

    protected

    ##
    # Attempt to authenticate an admin using their session token cookie
    ##
    def authenticate_staff
      authenticate_user

      error_msg = 'Not authorised.'
      raise Api::AuthError, error_msg unless @user.staff
    end
  end
end
