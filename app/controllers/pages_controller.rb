class PagesController < ApplicationController
  layout 'main'

  # force html
  before_action do
    request.format = :html
  end

  def home
  end

  def profile
  end

  def dashboard
  end
end
