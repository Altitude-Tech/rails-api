##
#
##
class Device < ApplicationRecord
  has_many :datum

  validates :device_id, uniqueness: true, hex: true
  validates :device_type, hex: true
end
