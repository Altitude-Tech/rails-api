require 'sensly/sensly'

##
# Representation of a processed data point in the database.
##
class Datum < ApplicationRecord
  ##
  # Constants
  ##

  ##
  # Associations
  ##
  belongs_to :device

  ##
  #
  ##
  after_validation :check_conc_presence

  ##
  # Validations
  ##
  validates :device_id, presence: true
  validates :log_time,
            datetime: { max: :now }
  validates :gas,
            gas_id: true
  validates :conc_ppm,
            numericality: { message: I18n.t('errors.must_be_num') },
            allow_nil: true
  validates :conc_ugm3,
            numericality: { message: I18n.t('errors.must_be_num') },
            allow_nil: true

  # getters and setters

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
  #
  ##
  def gas_name
    return Sensly::gas_name(self[:gas])
  end

  private

  ##
  #
  ##
  def check_conc_presence
    if self[:conc_ppm].nil? && self[:conc_ugm3].nil?
      msg = 'Either "conc_ppm" or "conc_ugm3" must be present'
      raise Record::ConcMissingError, msg
    end
  end
end
