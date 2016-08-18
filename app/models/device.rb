##
#
##
class Device < ApplicationRecord
  # @todo check which of these is correct
  # has_many :data
  # has_one :data

  validates :device_id, uniqueness: true, hex: true
  validates :device_type, hex: true
end
