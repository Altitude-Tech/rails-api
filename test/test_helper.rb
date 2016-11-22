ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# empty log file before running tests
log_file = File.expand_path('../../log/test.log', __FILE__)
File.open(log_file, 'w') {} if File.file? log_file

# add the time to the top of the file
now = Time.now.utc.to_formatted_s

Rails.logger.info '---------------------------------------'
Rails.logger.info "Starting tests: #{now}"
Rails.logger.info '---------------------------------------'

# make sure database is up to date before running tests
ActiveRecord::Migration.maintain_test_schema!

# content type to test against
JSON_TYPE = 'application/json'.freeze

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests
  # in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  USER_DATA = {
    name: 'Bob',
    email: 'bob@example.com',
    password: 'password'
  }.freeze

  ##
  # Login helper for controllers
  ##
  def login(user = nil, password = 'password')
    unless cookies.nil?
      if user.nil?
        user = User.create! USER_DATA.deep_dup
      end

      token = user.authenticate! password
      cookies.signed[:session] = token.token
    end
  end
end
