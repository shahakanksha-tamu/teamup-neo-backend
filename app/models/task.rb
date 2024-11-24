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
  validates :task_name, uniqueness: { scope: :milestone_id, message: 'must be unique within the same milestone' }
  validates :status, presence: true

  def status_color
    case status
    when 'Not Completed'
      '#B22222'
    when 'In-Progress'
      '#BDAA00'
    when 'Completed'
      '#006400'
    else
      '#4B4B4B'
    end
  end
end
