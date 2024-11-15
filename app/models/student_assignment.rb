# frozen_string_literal: true

# StudentAssignment maps each user to a specific project
class StudentAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  after_destroy :remove_student_tasks
  # Validations
  validates :user_id, presence: true
  validates :project_id, presence: true
  validates :user_id, uniqueness: { message: 'can only be assigned to a single project' }

  private

  def remove_student_tasks
    TaskAssignment.where(user_id: user_id).destroy_all
  end
end
