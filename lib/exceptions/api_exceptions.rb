##
#
##

require 'exceptions/exceptions'

module Api
  ##
  # Base API error.
  ##
  class Error < Sensly::Error
    attr_reader :code, :user_message

    def initialize(message)
      @code ||= 100

      super message
    end

    def format_attr(attribute, cap = true)
      attribute = attribute.to_s.tr '_', ' '

      if cap
        attribute = attribute.capitalize
      end

      return attribute
    end
  end

  ##
  # Authorisation error.
  ##
  class AuthError < Error
    def initialize(message)
      @code ||= 101

      super message
    end
  end

  ##
  # Authorisation error during login.
  ##
  class LoginAuthError < Error
    def initialize(exc)
      @code ||= 102

      attr_name = format_attr(exc.attribute, false)
      @user_message ||= "Incorrect or missing #{attr_name}."

      message = "Invalid or missing value for \"#{exc.attribute}\"."
      super message
    end
  end

  ##
  # Exception corresponding to `ActiveRecord::RecordInvalid` for `create` Api methods
  ##
  class InvalidCreateError < Error
    def initialize(exc)
      @code ||= 103

      record = exc.record
      key = record.errors.keys.first
      msg = record.errors[key].first

      user_key = I18n.t("models.#{record.class.name.downcase}.#{key}", default: format_attr(key))
      @user_message = "#{user_key} #{msg}."

      message = "\"#{key}\" #{msg}."
      super message
    end
  end

  ##
  # Exception corresponding to `ActiveRecord::NotFoundError`
  ##
  class NotFoundError < Error
    def initialize(key)
      @code ||= 104

      message = "\"#{key}\" not found."
      super message
    end
  end

  ##
  # Invalid or missing value for an API parameter.
  #
  # Only thrown if the value is checked before being passed to a model.
  ##
  class ArgumentError < Error
    def initialize(key)
      @code ||= 105

      message = "Invalid argument recieved for #{key}"
      super message
    end
  end

  ##
  # Exception corresponding to `Record::GroupMemberError`.
  ##
  class GroupMemberError < Error
    def initialize(message)
      @code ||= 106

      super message
    end
  end

  ##
  # Exception corresponding to `Record::DeviceRegistrationError`.
  ##
  class DeviceRegistrationError < Error
    def initialize(message)
      @code ||= 107

      super message
    end
  end

  ##
  # Exception corresponding to `Record::DeviceAuthError`.
  ##
  class DeviceAuthError < Error
    def initialize(message)
      @code ||= 108

      super message
    end
  end

  ##
  # Exception corresponsing to `JSON::ParserError`.
  ##
  class JsonParserError < Error
    def initialize(message)
      @code ||= 109

      super message
    end
  end

  ##
  # Exception corresponding to `ActiveRecord::RecordInvalid` for `update` Api methods
  ##
  class InvalidUpdateError < InvalidCreateError
    def initialize(exc)
      @code ||= 110

      super exc
    end
  end

  ##
  # Exception corresponding to `Record::UpdateError`
  ##
  class UpdateError < Error
    def initialize(message)
      @code ||= 111

      super message
    end
  end
end
