##
# Validator for hexadecimal strings
##
class HexValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    hex_regex = /\A[a-f0-9]+\Z/i
    record.errors.add attribute, I18n.t(:invalid_hex) unless value =~ hex_regex
  end
end
