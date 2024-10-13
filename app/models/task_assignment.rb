class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # Validations
  validates :user_id, presence: true
  validates :task_id, presence: true, uniqueness: true  # Ensuring task is only assigned to one user
end
  