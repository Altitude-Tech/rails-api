##
# Validator for Gas identities for Datum objects.
##
class GasIdValidator < BaseValidator
  ##
  #
  ##
  def validate_each(record, attribute, value)
    if Sensly::gas_name(value).nil?
        record.errors.add(attribute, I18n.t('errors.invalid_or_missing'))
    end
  end
end
