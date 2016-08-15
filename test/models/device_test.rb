##
# Device model tests
##

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
	##
	# Test error handling of invalid value for device id
	##
	test 'invalid device_id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => 'invalid', :device_type => 'abcd')
		end
	end

	##
	# Test error handling for duplicate creation
	#
	# Uses fixtures as original record
	##
	test 'duplicate device_id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => '1234', :device_type => 'abcd')
		end
	end

	##
	# Test error handling for missing device id
	##
	test 'missing device_id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => '1452')
		end
	end

	##
	# Test error handling of invalid value for device type
	##
	test 'invalid device_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => '1452', :device_type => 'invalid')
		end
	end

	##
	# Test error handling of missing device type
	##
	test 'missing device_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_type => 'abcd')
		end
	end

	##
	# Test error handling of missing device id and device type
	##
	test 'missing device_id and device_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!()
		end
	end

	##
	# Test successful creation
	##
	test 'successful insert' do
		Device.create!(:device_id => '1452', :device_type => 'abcd')
	end
end
