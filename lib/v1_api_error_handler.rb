##
#
##
module V1ApiErrorHandler
  protected

  ##
  # Renders error json as the response
  ##
  def render_error(error)
    @error = error
    render('v1/error', status: :bad_request)
  end

  ##
  # Error handler for StandardError
  ##
  def standard_error(exc)
    msg = ENV['RAILS_ENV'] == 'production' ?
      I18n.t('controller.api.v1.error.unhandled_error') :
      exc.message

    render_error(msg)
  end

  ##
  # Error handler for simple subclasses of StandardError
  ##
  def normal_error(exc)
    render_error(exc.message)
  end

  ##
  # Error handler for json parse error
  ##
  def json_parser_error(exc)
    msg = I18n.t('controller.v1.error.json_parse_error', msg: exc.message)
    render_error(msg)
  end

  ##
  # Error handler for ActiveRecord::RecordInvalid
  ##
  def record_invalid_error(exc)
    key = exc.record.errors.keys.first
    msg = I18n.t('controller.v1.error.invalid_value', key: key)
    render_error(msg)
  end

  ##
  # Error handler for ActiveModel::UnknownAttributeError
  ##
  def unknown_attr_error(exc)
    key = exc.attribute
    msg = I18n.t('controller.v1.error.unknown_key', key: key)
    render_error(msg)
  end
end
