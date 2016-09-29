module V1
  class GroupsController < V1::ApiController
    ##
    # Filters
    ##
    before_action :authenticate_user

    ##
    # Add a new user to a group
    ##
    def add_user
      is_admin?

      user = User.find_by_email! @body[:email]
      user.group = @user.group

      @result = 'success'
      render 'v1/result'
    rescue ActiveRecord::RecordNotFound
      raise Api::NotFoundError, 'email'
    rescue Record::GroupMemberError => exc
      raise Api::GroupMemberError, exc.message
    end

    ##
    # Create a new group.
    ##
    def create
      @body[:admin] = @user
      Group.create! @body

      @result = 'success'
      render 'v1/result'
    rescue ActiveRecord::RecordInvalid => exc
      raise Api::InvalidCreateError, exc
    rescue Record::GroupMemberError => exc
      raise Api::GroupMemberError, exc.message
    end

    ##
    # Get a group's details
    ##
    def show
      is_member?

      @group = @user.group
    end

    private

    ##
    # Check the user is a member of a group.
    ##
    def is_member?
      if @user.group.nil?
        msg = 'Not authorised.'
        raise Api::AuthError, msg
      end
    end

    ##
    # Check the user is an admin of a group.
    ##
    def is_admin?
      is_member?

      unless @user.group.admin.id == @user.id
        msg = 'Not authorised.'
        raise Api::AuthError, msg
      end
    end
  end
end
