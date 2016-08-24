##
# Validator for sensor types
##
class SensorValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, I18n.t(:invalid_sensor) unless Datum::SENSORS.include? value
  end
end
