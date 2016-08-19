##
# Represents a user
##
class User < ApplicationRecord
  validate :name, presence: true
  validate :email, presence: true
end
