##
# Validator for sensor types
##
class SensorTypeValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    condition = Datum::SENSORS.include?(value)

    msg = I18n.t('validator.unrecognised')
    record.errors.add(attribute, msg) unless condition
  end
end
