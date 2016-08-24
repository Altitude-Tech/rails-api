##
# Represents a device
##
class Device < ApplicationRecord
  has_many(:datum)

  before_validation(:debug_type_casting)

  validates(:device_id, uniqueness: true, hex: true)
  validates(:device_type, device_type: true)

  # constants
  TYPE_TEST_RAW = 'test'.freeze
  TYPE_SENSLY_RAW = 'sensly'.freeze

  TYPE_TEST = Digest::SHA1.hexdigest(TYPE_TEST_RAW).freeze
  TYPE_SENSLY = Digest::SHA1.hexdigest(TYPE_SENSLY_RAW).freeze

  TYPES = [TYPE_SENSLY].freeze

  TYPES_MAP = {
    TYPE_TEST => TYPE_TEST_RAW,
    TYPE_SENSLY => TYPE_SENSLY_RAW
  }.freeze

  ##
  #
  ##
  def name
    return TYPES_MAP[device_type]
  end
end
