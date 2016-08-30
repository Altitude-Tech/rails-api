##
#
##
module ErrorHandler
  protected

  ##
  # Renders error json as the response
  ##
  def render_error(error, status = :bad_request)
    @error = error
    render('v1/error', status: status)
  end

  ##
  # Error handler for StandardError
  ##
  def standard_error(exc)
    Rails.logger.debug("RAILS_ENV: #{ENV['RAILS_ENV']}")
    # don't squash the error in test mode
    # makes for really confusing error messages
    raise exc if ENV['RAILS_ENV'] == 'test'

    msg =
      if ENV['RAILS_ENV'] == 'production'
        I18n.t('controller.v1.error.unhandled_error')
      else
        exc.message
      end

    # @todo use mailers here?
    Rails.logger.error(exc.message)

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
  # Error handler for ActiveRecord::RecordNotFound
  #
  # Usually only catches error in `show` methods
  ##
  def not_found_error(exc)
    args = { model: exc.model.downcase, key: exc.key, value: exc.value }
    msg = I18n.t('controller.v1.error.not_found', args)
    render_error(msg, :not_found)
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
