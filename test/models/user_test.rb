##
#
##

require 'test_helper'

##
#
##
class UserTest < ActiveSupport::TestCase
  ##
  #
  ##
  BASE_DATA =  {
    name: 'test user',
    email: 'test@example.com',
    password: 'password'
  }.freeze

  ##
  #
  ##
  #test 'successful create' do
  #  data = BASE_DATA.deep_dup

  #  User.create!(data)
  #end
end
