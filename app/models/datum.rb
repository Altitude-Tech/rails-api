##
# Model representing a device's data
##
class Datum < ApplicationRecord
  ##
  # Relationships
  ##
  belongs_to(:device)

  ##
  # Callbacks
  ##
  # before_create(:convert_to_si_units)

  ##
  # Validations
  ##
  validates(:sensor_type, sensor_type: true)
  validates(:sensor_error, numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            })
  validates(:sensor_data, sensor_data: true)
  validates(:log_time, log_time: true)
  validates(:device_id, presence: true)
  validates(:temperature, numericality: true)
  validates(:pressure, numericality: {
              greater_than_or_equal_to: 0
            })
  validates(:humidity, numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            })

  ##
  # Constants
  ##
  SENSOR_MQ2_RAW = 'mq2'.freeze
  SENSOR_MQ7_RAW = 'mq7'.freeze
  SENSOR_MQ135_RAW = 'mq135'.freeze

  SENSOR_MQ2 = Digest::SHA1.hexdigest(SENSOR_MQ2_RAW)
  SENSOR_MQ7 = Digest::SHA1.hexdigest(SENSOR_MQ7_RAW)
  SENSOR_MQ135 = Digest::SHA1.hexdigest(SENSOR_MQ135_RAW)

  SENSORS = [SENSOR_MQ2, SENSOR_MQ7, SENSOR_MQ135].freeze

  SENSOR_MAP = {
    SENSOR_MQ2 => SENSOR_MQ2_RAW,
    SENSOR_MQ7 => SENSOR_MQ7_RAW,
    SENSOR_MQ135 => SENSOR_MQ135_RAW
  }.freeze

  ##
  # Get the unhashed string representation of a sensor type
  ##
  def sensor_name
    return SENSOR_MAP[self.sensor_type]
  end

  ##
  # Convert log_time from unix to mysql format
  ##
  def log_time=(log_time)
    log_time = Time.at(Integer(log_time)).utc.to_s(:db)
    self[:log_time] = log_time
  rescue TypeError, ArgumentError
    self[:log_time] = nil
  end

  ##
  # Format log time before it gets output
  ##
  def log_time
    return Time.parse(self[:log_time].to_s).utc.to_formatted_s
  rescue ArgumentError
    return nil
  end

  private

  ##
  # Convert certain attributes to their SI units
  #
  # @todo fix me? add tests at least
  ##
  def convert_to_si_units
    # convert pressure from hecto-pascals to pascals
    self.pressure *= 100

    # convert temperaturature from celsius to kelvin
    self.temperature = Concentration.centigrade_to_kelvin(self.temperature)
  end
end
