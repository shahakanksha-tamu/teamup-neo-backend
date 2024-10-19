# frozen_string_literal: true

# StudentAssignment maps each user to a specific project
class StudentAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :project

  # Validations
  validates :user_id, presence: true
  validates :project_id, presence: true
  validates :user_id, uniqueness: { scope: :project_id, message: 'can only be assigned to a single project' }
end
