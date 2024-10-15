# frozen_string_literal: true

class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # Validations
  validates :user_id, presence: true
  validates :task_id, presence: true
end
