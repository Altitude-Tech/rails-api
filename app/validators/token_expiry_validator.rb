##
# Validator for log_time
##
class TokenExpiryValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    msg_invalid = I18n.t('validator.token_expires_invalid')
    msg_out_of_range = I18n.t('validator.token_expires_out_of_range')

    # because the initial value is typecasted and set to nil if it's not a valid time
    # we need to validate against that value in order to get the correct error message
    # however, nil is also a valid value, as it indicates the token should never expire
    if value.nil?
      raw_value = get_raw_value(record, attribute, value)
      return if raw_value.nil?

      record.errors.add(attribute, msg_invalid) && return
    end

    record.errors.add(attribute, msg_out_of_range) unless value > Time.now.utc
  end
end
