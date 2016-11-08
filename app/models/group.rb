require 'exceptions/record_exceptions'

##
# Model representing a group in the database.
##
class Group < ApplicationRecord
  ##
  # Associations
  ##
  belongs_to :user, foreign_key: :admin, optional: true
  has_many :user
  has_many :device

  ##
  # Validations
  ##
  validates :name, length: { maximum: 255 }, allow_nil: true
  validates :admin, presence: true, uniqueness: true

  ##
  # Callbacks
  ##
  after_create :add_admin_to_group

  ##
  # Setter for admin.
  ##
  def admin=(value)
    if value.is_a? User
      unless value.group.nil?
        msg = 'User is already a member of a group.'
        raise Record::GroupMemberError, msg
      end

      self[:admin] = value.id
      return
    end

    self[:admin] = value
  end

  ##
  # Getter for admin.
  ##
  def admin
    return User.find(self[:admin])
  end

  ##
  # Get all users in a group.
  ##
  def users
    return User.where group_id: self[:id]
  end

  ##
  # Get all devices in a group.
  ##
  def devices
    return Device.where group_id: self[:id]
  end

  private

  ##
  # Add the admin user to the group.
  ##
  def add_admin_to_group
    admin.update! group: self
  end
end
