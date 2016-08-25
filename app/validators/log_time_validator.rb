##
# Validator for log_time
##
class LogTimeValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    now = Time.now.utc
    limit = now - 30.days
    # the maximum time that can be stored in unix time assuming unisigned 32 bit ints
    max_unix = Time.at(2**32 -1).utc

    msg_invalid = I18n.t('validator.log_time_invalid')
    msg_range = I18n.t('validator.log_time_out_of_range')

    # also check for above max value of unix time
    # to give a more helpful error if it's given in milliseconds
    if value.nil? || value > max_unix
      record.errors.add(attribute, msg_invalid)
      return
    end

    record.errors.add(attribute, msg_range) unless (limit..now).cover?(value)
  end
end
