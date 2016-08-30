##
# Validator for device types
##
class DeviceTypeValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    value = get_raw_value(record, attribute, value)

    is_valid = Device::TYPES.include?(value)
    not_prod = ENV['RAILS_ENV'] != 'production'
    is_test = value == Device::TYPE_TEST

    condition = is_valid || (not_prod && is_test)

    msg = I18n.t('validator.unrecognised')
    record.errors.add(attribute, msg) unless condition
  end
end
