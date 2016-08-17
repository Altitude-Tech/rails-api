class Datum < ApplicationRecord
  # make sure this is a hex number
  validates :sensor_type, sensor: true
  validates :sensor_error,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 1
    }
  validates :sensor_data,
    numericality: {
      greater_than_or_equal_to: 0
    }
  validates :log_time, presence: true
  validates :device_id, presence: true
end
