##
# Validator for device types
##
class DeviceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    is_valid = Device::TYPES.include?(value)
    not_prod = ENV['RAILS_ENV'] != 'production'
    is_test = value == Device::TYPE_TEST

    msg = I18n.t(:invalid_device)

    record.errors.add(attribute, msg) unless is_valid || (not_prod && is_test)
  end
end
