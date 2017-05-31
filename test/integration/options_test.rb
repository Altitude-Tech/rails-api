require "test_helper"

class OptionsTest < ActionDispatch::IntegrationTest
  def test_options
    open_session do |sess|
      sess.process :options, '/example'
    end
  end
end
