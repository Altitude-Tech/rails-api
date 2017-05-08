##
# Validator for device identity objects.
##
class SensorR0Validator < BaseValidator
  NO_R0_SENSORS = [
    RawDatum::SENSOR_PM
  ].freeze

  ##
  #
  ##
  def validate_each(record, attribute, value)
    if NO_R0_SENSORS.include?(record[:sensor_type])
      unless value.nil?
        msg = 'should not be present'
        record.errors.add(attribute, msg)
      end

    elsif value.nil?
      msg = 'must be present'
      record.errors.add(attribute, msg)
    end
  end
end
