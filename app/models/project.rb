# frozen_string_literal: true

# Project class contains all the details of the project, including timeline and list of milestones
class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false, message: 'Title must be unique' }
  has_many :student_assignments, dependent: :destroy
  has_many :users, through: :student_assignments
  has_many :milestones, dependent: :destroy
  has_one :timeline, dependent: :destroy
  has_many :resources, dependent: :destroy

  # Add a student to a project (team)
  def add_student(user)
    StudentAssignment.create(user_id: user.id, project_id: id)
  end

  # Remove a student from a project (team)
  def remove_student(user)
    student_assignment = StudentAssignment.find_by(user_id: user.id, project_id: id)
    student_assignment&.destroy
  end

  # Get all students in the project (team members)
  def team_members
    users
  end

  def progress
    return 0 if milestones.count.zero?

    completed_milestones = milestones.where(status: 'Completed').count
    ((completed_milestones.to_f / milestones.count) * 100).round(2)
  end
end
