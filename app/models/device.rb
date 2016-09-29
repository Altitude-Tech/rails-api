##
# Representation of a device in the database.
##
class Device < ApplicationRecord
  ##
  # Constants
  ##
  TYPE_MAIN = 1
  TYPE_HAT = 2
  TYPE_GO = 3
  TYPE_PRO = 4

  TYPE_MAIN_NAME = 'main'.freeze
  TYPE_HAT_NAME = 'hat'.freeze
  TYPE_GO_NAME = 'go'.freeze
  TYPE_PRO_NAME = 'pro'.freeze

  TYPE_MAIN_HASH = Digest::SHA1.hexdigest(TYPE_MAIN_NAME).freeze
  TYPE_HAT_HASH = Digest::SHA1.hexdigest(TYPE_HAT_NAME).freeze
  TYPE_GO_HASH = Digest::SHA1.hexdigest(TYPE_GO_NAME).freeze
  TYPE_PRO_HASH = Digest::SHA1.hexdigest(TYPE_PRO_NAME).freeze

  TYPES = [TYPE_MAIN, TYPE_HAT, TYPE_GO, TYPE_PRO].freeze

  TYPE_MAP_DB_TO_NAME = {
    TYPE_MAIN => TYPE_MAIN_NAME,
    TYPE_HAT => TYPE_HAT_NAME,
    TYPE_GO => TYPE_GO_NAME,
    TYPE_PRO => TYPE_PRO_NAME
  }.freeze

  TYPE_MAP_HASH_TO_DB = {
    TYPE_MAIN_HASH => TYPE_MAIN,
    TYPE_HAT_HASH => TYPE_HAT,
    TYPE_GO_HASH => TYPE_GO,
    TYPE_PRO_HASH => TYPE_PRO
  }.freeze

  TYPE_MAP_DB_TO_HASH = {
    TYPE_MAIN => TYPE_MAIN_HASH,
    TYPE_HAT => TYPE_HAT_HASH,
    TYPE_GO => TYPE_GO_HASH,
    TYPE_PRO => TYPE_PRO_HASH
  }.freeze

  ##
  # Associations
  ##
  has_many :datum
  belongs_to :group, optional: true
  belongs_to :token, foreign_key: :token, optional: true

  ##
  # Validations
  ##
  validates :identity, uniqueness: true, device_identity: true
  validates :device_type, device_type: true

  ##
  #
  ##
  before_validation :generate_identity

  ##
  # Getter for group.
  ##
  def group
    # TODO: test this
    if self[:group_id].nil?
      return self[:group_id]
    end

    return Group.find self[:group_id]
  end

  ##
  # Setter for device_type.
  ##
  def device_type=(value)
    self[:device_type] = TYPE_MAP_HASH_TO_DB[value] || value
  end

  ##
  # Getter for device_type.
  ##
  def device_type
    return TYPE_MAP_DB_TO_HASH[self[:device_type]]
  end

  ##
  # Get the unhashed string representation of a device type.
  ##
  def name
    return TYPE_MAP_DB_TO_NAME[self[:device_type]]
  end

  ##
  # Getter for token
  ##
  def token
    return Token.find self[:token]
  end

  ##
  # Set and return the device's token.
  ##
  def register!(group = nil)
    if group.nil?
      msg = 'Device must be assigned a group.'
      raise Record::DeviceRegistrationError, msg
    end

    begin
      unless group.is_a? Group
        group = Group.find group
      end
    rescue ActiveRecord::RecordNotFound
      msg = 'Device must be assigned a group.'
      raise Record::DeviceRegistrationError, msg
    end

    unless self[:token].nil?
      msg = 'Device is already registered.'
      raise Record::DeviceRegistrationError, msg
    end

    Device.transaction do
      token = Token.create!
      update! token: token, group: group
    end

    return token
  end

  ##
  # Authenticate a device using it's token
  ##
  def authenticate!(token = nil)
    if self[:token].nil? || self[:token] != token
      msg = 'Not authorised.'
      raise Record::DeviceAuthError, msg
    end
  end

  private

  ##
  # Generate the device's `identity` attribute if it does not already exist
  ##
  def generate_identity
    self[:identity] ||= SecureRandom.hex
  end
end
