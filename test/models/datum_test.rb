##
# Datum model tests
##

require 'test_helper'

class DatumTest < ActiveSupport::TestCase
	##
	# Test error handling for invalid sensor type
	##
	test 'invalid sensor_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => 'invalid',
				:sensor_error => 0,
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for missing sensor type
	##
	test 'missing sensor type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_error => 0,
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for too high sensor error
	##
	test 'too high sensor error' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 2,
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for too low sensor error
	##
	test 'too low sensor error' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => -1,
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for invalid value for sensor error
	##
	test 'invalid sensor error' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 'invalid',
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for missing sensor error
	##
	test 'missing sensor error' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for too low sensor data
	##
	test 'too low sensor data' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:sensor_data => -1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for invalid value for sensor data
	##
	test 'invalid sensor data' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:sensor_data => 'invalid',
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for missing sensor data
	##
	test 'missing sensor data' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for invalid value for log time
	##
	test 'invalid log time' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:sensor_data => 1,
				:log_time => 'invalid',
				:device_id => 1234)
		end
	end

	##
	# Test error handling for missing log time
	##
	test 'missing log time' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:sensor_data => 1,
				:device_id => 1234)
		end
	end

	##
	# Test error handling for invalid value for device id
	##
	test 'invalid device id' do
		assert_raises(ActiveRecord::InvalidForeignKey) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36',
				:device_id => 'invalid')
		end
	end

	##
	# Test error handling for missing device id
	##
	test 'missing device id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Datum.create!(:sensor_type => '1234',
				:sensor_error => 0,
				:sensor_data => 1,
				:log_time => '2016-07-13 16:31:36')
		end
	end

	##
	# Test successful creation
	##
	test 'successful create' do
		device = Device.first!

		Datum.create!(:sensor_type => '1234',
			:sensor_error => 0,
			:sensor_data => 1,
			:log_time => '2016-07-13 16:31:36',
			:device_id => device.id)
	end
end
