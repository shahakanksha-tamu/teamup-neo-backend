# frozen_string_literal: true

# TaskAssginment assigns a single task to a student and maps the association
class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # Validations
  validates :user_id, presence: true
  validates :task_id, presence: true
  after_destroy :cleanup_orphaned_tasks

  private
  def cleanup_orphaned_tasks
    if TaskAssignment.where(task_id: task_id).empty?
      task.destroy if task.present? # Delete the task if no assignments exist
    end
  end
end
