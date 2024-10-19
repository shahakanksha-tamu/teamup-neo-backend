# frozen_string_literal: true

# TaskAssginment assigns a single task to a student and maps the association
class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # Validations
  validates :user_id, presence: true
  validates :task_id, presence: true
end
