# frozen_string_literal: true

# The User class represents a user in the application.
# It inherits from ApplicationRecord and contains information related to users like first name, last name, email, role
class User < ApplicationRecord
  enum :role, { student: 0, admin: 1 }
end
