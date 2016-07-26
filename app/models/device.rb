class Device < ApplicationRecord
	# @todo check which of these is correct
	# has_many :data
	# has_one :data

	# make sure both are hex numbers
	validates :device_id,
		uniqueness: true,
		format: {
			with: /\A[a-f0-9]+\Z/i
		}
	validates :device_type,
		format: {
			with: /\A[a-f0-9]+\Z/i
		}
end
