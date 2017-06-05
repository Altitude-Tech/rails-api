class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # default to json
  # but allow html if requested
  before_action do
    if request.format.nil?
      request.format = :json
    end

    unless [:html, :json].include? request.format
      # TODO: throw exception here
    end
  end

  def handle_request_error
  end

  def handle_unknown_error
  end
end
