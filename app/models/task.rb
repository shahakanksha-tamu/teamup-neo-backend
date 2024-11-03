# frozen_string_literal: true

# Task represents individual student tasks associated to a particular milestone
class Task < ApplicationRecord
  belongs_to :milestone
  has_one :task_assignment, dependent: :destroy
  has_one :user, through: :task_assignment
  enum status: {
    'Not Started' => 'Not Started',
    'Completed' => 'Completed',
    'In-Progress' => 'In-Progress',
    'Not Completed' => 'Not Completed'
  }

  # Validations
  validates :task_name, presence: true
  validates :status, presence: true

  def status_color
    case status
    when 'Not Completed'
      '#B22222'  # Light red for pending
    when 'In-Progress'
      '#BDAA00'  # Light yellow for in-progress
    when 'Completed'
      '#006400'  # Light green for completed
    else
      '#4B4B4B'  # Light gray as a default
    end
  end
end
