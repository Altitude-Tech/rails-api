##
# Model representing a device
##
class Device < ApplicationRecord
  ##
  # Relationships
  ##
  has_many(:datum)

  ##
  # Validations
  ##
  validates(:device_id, uniqueness: true, hex: true)
  validates(:device_type, device_type: true)

  ##
  # Constants
  ##
  TYPE_TEST_DB = 1
  TYPE_SENSLY_DB = 2

  TYPE_TEST_RAW = 'test'.freeze
  TYPE_SENSLY_RAW = 'sensly'.freeze

  TYPE_TEST = Digest::SHA1.hexdigest(TYPE_TEST_RAW).freeze
  TYPE_SENSLY = Digest::SHA1.hexdigest(TYPE_SENSLY_RAW).freeze

  TYPES = [TYPE_SENSLY].freeze

  TYPE_MAP_DB_TO_RAW = {
    TYPE_TEST_DB => TYPE_TEST_RAW,
    TYPE_SENSLY_DB => TYPE_SENSLY_RAW
  }.freeze

  TYPE_MAP_HASH_TO_DB = {
    TYPE_TEST => TYPE_TEST_DB,
    TYPE_SENSLY => TYPE_SENSLY_DB
  }.freeze

  TYPE_MAP_DB_TO_HASH = {
    TYPE_TEST_DB => TYPE_TEST,
    TYPE_SENSLY_DB => TYPE_SENSLY
  }.freeze

  ##
  #
  ##
  def device_type=(device_type)
    self[:device_type] = TYPE_MAP_HASH_TO_DB[device_type]
  rescue KeyError
    self[:device_type] = nil
  end

  ##
  #
  ##
  def device_type
    return TYPE_MAP_DB_TO_HASH[self[:device_type]]
  end

  ##
  # Get the unhashed string representation of a device type
  ##
  def name
    return TYPE_MAP_DB_TO_RAW[self[:device_type]]
  end
end
