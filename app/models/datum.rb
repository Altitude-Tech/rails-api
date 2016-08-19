##
#
##
class Datum < ApplicationRecord
  belongs_to :device

  before_create :convert_to_si_units

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

  def convert_to_si_units
    # convert pressure from hecto-pascals to pascals
    self.pressure *= 100

    # convert temperaturature from celsius to kelvin
    self.temperature = Concentration.centigrade_to_kelvin(self.temperature)
  end
end
