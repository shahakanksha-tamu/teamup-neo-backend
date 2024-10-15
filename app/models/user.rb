# frozen_string_literal: true

# The User class represents a user in the application.
# It inherits from ApplicationRecord and contains information related to users like first name, last name, email, role
class User < ApplicationRecord
  has_one :student_assignment, dependent: :destroy
  has_one :project, through: :student_assignment
  has_many :task_assignments, dependent: :destroy
  has_many :tasks, through: :task_assignments
  enum :role, { student: 0, admin: 1 }

  def full_name
    "#{first_name} #{last_name}"
  end
  
end
