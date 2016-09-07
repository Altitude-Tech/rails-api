##
#
##

require 'exceptions'

##
#
##
module V1
  ##
  #
  ##
  class GroupsController < V1ApiController
    ##
    # Callbacks
    ##
    before_action(:load_user, only: [:create, :add_users, :remove_users, :change_name])
    before_action(:load_group, only: [:add_users, :remove_users, :change_name])

    ##
    # Create a new group
    ##
    def create
      @json[:admin] = @user
      Group.create!(@json)

      @result = I18n.t('controller.v1.message.success')
      render('v1/result')
    end

    ##
    # Get a list of groups
    ##
    def index
      # id
      # admin
      # name
    end

    ##
    # Get details about a specific group
    ##
    def show
      # list users
      # list devices
    end

    ##
    # Add users to a group
    ##
    def add_users
      puts @user
      puts @group
      puts @json[:users]
      puts @group.admin?(@user)

      @json[:users].each do |email|
        begin
          user = User.find_by_email!(email)
          user.group_id = @group.id
        rescue
        end
      end

      # check if the user is admin of the group

      # add users based on email address

      # add users in a loop and report back on success of each
      # check user email is valid, etc.
    end

    ##
    # Remove users from a group
    ##
    def remove_users
      puts @user
      puts @group
      puts @json[:users]
      puts @group.admin?(@user)
    end

    ##
    # Change a group's name
    ##
    def change_name
      puts @user
      puts @group
      puts @json[:group_name]
      puts @group.admin?(@user)
    end

    private

    ##
    #
    ##
    def load_user
      session_token = cookies.signed[:session]
      @user = User.find_by_session_token!(session_token)
    rescue ActiveRecord::RecordNotFound
      # delete session as it's not valid anyway
      cookies.delete(:session) if cookies.key?(:session)

      msg = I18n.t('controller.v1.error.logged_out')
      raise Exceptions::V1ApiInvalidSessionError, msg
    end

    ##
    #
    ##
    def load_group
      @group = @user.group
    end
  end
end
