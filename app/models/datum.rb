##
# Represents a device's data
##
class Datum < ApplicationRecord
  belongs_to :device

  before_validation(:convert_raw_log_time)
  before_create(:convert_to_si_units)

  validates(:sensor_type, sensor_type: true)
  validates(:sensor_error, numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            })
  validates(:sensor_data, sensor_data: true)
  validates(:log_time, log_time: true)
  validates(:device_id, presence: true)
  validates(:temperature, numericality: true)
  validates(:pressure, numericality: { greater_than_or_equal_to: 0 })
  validates(:humidity, numericality: { greater_than_or_equal_to: 0 })

  ##
  # Sensors
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
  # Get a string representing the sensor's name
  ##
  def sensor_name
    return SENSOR_MAP[self.sensor_type]
  end

  private

  ##
  #
  ##
  def convert_raw_log_time
    log_time = self.log_time.nil? ? self.log_time_before_type_cast : self.log_time
    log_time = Integer(log_time)

    self.log_time = Time.at(log_time).utc.to_s(:db)
  rescue TypeError, ArgumentError
    nil
  end

  ##
  # @todo fix me?, possibly not working according to tests
  ##
  def convert_to_si_units
    # convert pressure from hecto-pascals to pascals
    self.pressure *= 100

    # convert temperaturature from celsius to kelvin
    self.temperature = Concentration.centigrade_to_kelvin(self.temperature)
  end
end
