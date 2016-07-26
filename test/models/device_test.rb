require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
	test 'invalid device_id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => 'invalid', :device_type => 'abcd')
		end
	end

	test 'duplicate device_id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			# already in database, see test/fixtures/devices.yml
			Device.create!(:device_id => '1234', :device_type => 'abcd')
		end
	end

	test 'missing device_id' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => '1452')
		end
	end

	test 'invalid device_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_id => '1452', :device_type => 'invalid')
		end
	end

	test 'missing device_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!(:device_type => 'abcd')
		end
	end

	test 'missing device_id and device_type' do
		assert_raises(ActiveRecord::RecordInvalid) do
			Device.create!()
		end
	end

	test 'successful insert' do
		Device.create!(:device_id => '1452', :device_type => 'abcd')
	end
end
