# frozen_string_literal: true

# The User class represents a user in the application.
# It inherits from ApplicationRecord and contains information related to users like first name, last name, email, role
class User < ApplicationRecord
  has_many :student_assignments
  has_many :projects, through: :student_assignments
  has_many :task_assignments
  has_many :tasks, through: :task_assignments
end

