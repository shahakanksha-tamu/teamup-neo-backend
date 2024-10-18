# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :student_assignments, dependent: :destroy
  has_many :users, through: :student_assignments
  has_many :milestones, dependent: :destroy
  has_one :timeline, dependent: :destroy
    # Add a student to a project (team)
    def add_student(user)
      StudentAssignment.create(user_id: user.id, project_id: self.id)
    end
  
    # Remove a student from a project (team)
    def remove_student(user)
      student_assignment = StudentAssignment.find_by(user_id: user.id, project_id: self.id)
      student_assignment&.destroy
    end
  
    # Get all students in the project (team members)
    def team_members
      self.users
    end
  has_many :resources, dependent: :destroy
end
