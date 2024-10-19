# frozen_string_literal: true

# Task represents individual student tasks associated to a particular milestone
class Task < ApplicationRecord
  belongs_to :milestone
  has_one :task_assignment, dependent: :destroy
  has_one :user, through: :task_assignment
  enum status: {
    'Not Completed' => 'Not Completed',
    'Completed' => 'Completed',
    'Delayed' => 'Delayed'
  }

  # Validations
  validates :task_name, presence: true
  validates :status, presence: true
end
