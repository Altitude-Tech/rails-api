##
# Validator for hexadecimal strings
##
class HexValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    value = get_raw_value(record, attribute, value)
    hex_regex = /\A[a-f0-9]+\Z/i
    condition = value =~ hex_regex

    msg = I18n.t('validator.hex')
    record.errors.add(attribute, msg) unless condition
  end
end
