##
#
##

require 'exceptions'

##
# Model representing a group of users
##
class Group < ApplicationRecord
  ##
  # Callbacks
  ##
  after_create(:add_admin_to_group)

  ##
  # Associations
  ##
  belongs_to(:user, foreign_key: :admin, optional: true)
  has_many(:user, foreign_key: :group_id)
  # has_many(:device)

  ##
  # Validations
  ##
  validates(:admin, presence: true)
  validates(:name, length: { maximum: 255 }, allow_nil: true)

  ##
  #
  ##
  def self.create!(params = nil)
    if params.is_a?(Hash) && params.key?(:admin) && params[:admin].is_a?(User)
      # don't let the user create their own group
      # if they're already in one
      unless params[:admin].group_id.nil?
        # @todo set message for this
        msg = ''
        raise Exceptions::GroupInGroupError, msg
      end
    end

    super(params)
  end

  ##
  # Getter for group admin
  ##
  def admin
    return User.find(self[:admin])
  end

  ##
  # Setter for group admin
  ##
  def admin=(admin)
    self[:admin] = admin.is_a?(User) ? admin.id : admin
  end

  ##
  # Test if a user is a group admin
  ##
  def admin?(user)
    return self[:admin] == user.id
  end

  private

  ##
  # Add admin to a newly created group
  ##
  def add_admin_to_group
    admin.update!(group_id: self[:id])
  end
end
