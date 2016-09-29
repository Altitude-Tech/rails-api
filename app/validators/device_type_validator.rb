##
# Validator for device type objects.
##
class DeviceTypeValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, _value)
    # work with the raw value
    # otherwise you end up working with the hash representations of the types
    # and invalid/missing values are more confusing
    raw_value = before_type_cast record, attribute

    unless Device::TYPES.include? raw_value
      msg = 'is an invalid value'
      record.errors.add(attribute, msg)
    end
  end
end
