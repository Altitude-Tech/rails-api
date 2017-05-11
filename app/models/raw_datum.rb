##
# Representation of a raw, unprocessed data point in the database.
##
class RawDatum < ApplicationRecord
  ##
  # Constants
  ##
  SENSOR_MQ2 = 1
  SENSOR_MQ7 = 2
  SENSOR_MQ135 = 3
  SENSOR_PM = 4

  SENSOR_MQ2_NAME = 'mq2'.freeze
  SENSOR_MQ7_NAME = 'mq7'.freeze
  SENSOR_MQ135_NAME = 'mq135'.freeze
  SENSOR_PM_NAME = 'pm'.freeze

  SENSOR_MQ2_HASH = Digest::SHA1.hexdigest(SENSOR_MQ2_NAME).freeze
  SENSOR_MQ7_HASH = Digest::SHA1.hexdigest(SENSOR_MQ7_NAME).freeze
  SENSOR_MQ135_HASH = Digest::SHA1.hexdigest(SENSOR_MQ135_NAME).freeze
  SENSOR_PM_HASH = Digest::SHA1.hexdigest(SENSOR_PM_NAME).freeze

  SENSOR_MAP_HASH_TO_DB = {
    SENSOR_MQ2_HASH => SENSOR_MQ2,
    SENSOR_MQ7_HASH => SENSOR_MQ7,
    SENSOR_MQ135_HASH => SENSOR_MQ135,
    SENSOR_PM_HASH => SENSOR_PM
  }.freeze

  SENSOR_MAP_DB_TO_HASH = {
    SENSOR_MQ2 => SENSOR_MQ2_HASH,
    SENSOR_MQ7 => SENSOR_MQ7_HASH,
    SENSOR_MQ135 => SENSOR_MQ135_HASH,
    SENSOR_PM => SENSOR_PM_HASH
  }.freeze

  SENSOR_MAP_DB_TO_NAME = {
    SENSOR_MQ2 => SENSOR_MQ2_NAME,
    SENSOR_MQ7 => SENSOR_MQ7_NAME,
    SENSOR_MQ135 => SENSOR_MQ135_NAME,
    SENSOR_PM => SENSOR_PM_NAME
  }.freeze

  ##
  # Associations
  ##
  belongs_to :device

  ##
  # Validations
  ##
  validates :device_id,
            presence: true
  validates :sensor_type,
            presence: { message: I18n.t('errors.invalid_or_missing') }
  validates :sensor_error,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1,
              message: I18n.t('errors.must_be_num_ge_le', min: 0, max: 1)
            }
  validates :sensor_data,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than: 4096,
              message: I18n.t('errors.must_be_int_ge_lt', min: 0, max: 4096)
            }
  validates :sensor_r0,
            numericality: { allow_nil: true },
            sensor_r0: true
  validates :log_time,
            datetime: { min: (Time.now.utc - 30.days), max: :now }
  validates :temperature,
            numericality: { message: I18n.t('errors.must_be_num') }
  validates :pressure,
            numericality: { message: I18n.t('errors.must_be_num') }
  validates :humidity,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100,
              message: I18n.t('errors.must_be_num_ge_le', min: 0, max: 100)
            }

  ##
  # Setter for `log_time`.
  #
  # Converts unix time to mysql datetime format.
  ##
  def log_time=(value)
    value = Integer value
    value = Time.at(value).utc.to_s(:db)

    self[:log_time] = value
  rescue TypeError, ArgumentError
    self[:log_time] = value
  end

  ##
  # Setter for sensor_type.
  ##
  def sensor_type=(value)
    self[:sensor_type] = SENSOR_MAP_HASH_TO_DB.fetch(value)
  rescue KeyError
    self[:sensor_type] = nil
  end

  ##
  # Getter for sensor_type.
  ##
  def sensor_type
    return SENSOR_MAP_DB_TO_HASH[self[:sensor_type]]
  end

  ##
  # Get the unhashed string representation of a sensor type.
  ##
  def sensor_name
    return SENSOR_MAP_DB_TO_NAME[self[:sensor_type]]
  end
end
