# This file should contain all the record creation needed to seed
# the database with its default values.
#
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

##
# Create default user
##
begin
  user_data = {
    name: 'Default',
    email: 'example@example.com',
    password: 'password'
  }

  user = User.create! user_data
rescue ActiveRecord::RecordInvalid
  user = User.find_by! email: user_data[:email]
end

##
# Create default group
##
begin
  group_data = {
    name: 'Default group',
    admin: user
  }

  group = Group.create! group_data
rescue Activerecord::RecordInvalid
  group = user.group
end

##
# Create default device
##
begin
  device_data = {
    identity: '00000000000000000000000000000000',
    device_type: Device::TYPE_MAIN_HASH
  }

  device = Device.create! device_data
rescue ActiveRecord::RecordInvalid
  device = device.find_by! identity: '00000000000000000000000000000000'
end

##
# Register the device
##
begin
  token = Token.create! token: '00000000000000000000000000000000', enabled: true
  device.update! group: group, token: token
# rubocop:disable Lint/HandleExceptions
rescue ActiveRecord::RecordInvalid
  # token already created
rescue Record::DeviceRegistrationError
  # device already registered
end
# rubocop:enable Lint/HandleExceptions
