##
# Validator for device identity objects.
##
class DeviceIdentityValidator < BaseValidator
  ##
  #
  ##
  HEX_REGEX = /[0-9a-f]/i

  ##
  #
  ##
  def validate_each(record, attribute, value)
    unless value =~ HEX_REGEX && value.length == 32
      msg = 'is an invalid value'
      record.errors.add(attribute, msg)
    end
  end
end
