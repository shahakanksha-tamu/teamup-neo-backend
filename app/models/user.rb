# frozen_string_literal: true

# The User class represents a user in the application.
# It inherits from ApplicationRecord and contains information related to users like first name, last name, email, role
class User < ApplicationRecord
  has_one :student_assignments
  has_one :project, through: :student_assignments
  has_many :task_assignments
  has_many :tasks, through: :task_assignments
  enum :role, { student: 0, admin: 1 }
end

