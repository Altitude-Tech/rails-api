##
#
##

require 'validation'

##
# Validator for sensor data
##
class SensorDataValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    value = get_raw_value(record, attribute, value)
    # must be a 12 bit unsigned integer
    max = 2**12 - 1

    Validation.validate_int(value, 0, max)
  rescue ArgumentError
    msg = I18n.t('validator.unrecognised')
    record.errors.add(attribute, msg)
  end
end
