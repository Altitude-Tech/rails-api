##
#
##
class Datum < ApplicationRecord
  before_create :convert_log_time

  validates(:sensor_type, sensor: true)
  validates(:sensor_error,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            })
  validates(:sensor_data,
            numericality: { greater_than_or_equal_to: 0 })
  validates(:log_time, presence: true)
  validates(:device_id, presence: true)
  validates(:temperature, numericality: true)
  validates(:pressure,
            numericality: { greater_than_or_equal_to: 0 })
  validates(:humidity,
            numericality: { greater_than_or_equal_to: 0 })

  private

  def convert_log_time
    # catch out any non-integers
    log_time = Integer(log_time)

    # convert unix time to sql datetime format
    Time.at(log_time).to_s(:db)
  rescue TypeError, ArgumentError
    errors.add(:log_time, I18n.t(:must_be_unix_time))
  end
end
