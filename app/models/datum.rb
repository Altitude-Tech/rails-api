class Datum < ApplicationRecord
	# make sure this is a hex number
	validates :sensor_type,
		format: {
			with: /\A[a-f0-9]+\Z/i
		}
	validates :sensor_error,
		numericality: {
			greater_than_or_equal_to: 0,
			less_than_or_equal_to: 0
		}
	validates :sensor_data,
		numericality: {
			greater_than_or_equal_to: 0
		}
	validates :log_time,
		presence: true
	validates :device_id,
		presence: true
end

