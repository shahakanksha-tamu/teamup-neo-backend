class Task < ApplicationRecord
  belongs_to :milestone
  has_many :task_assignments
  has_many :users, through: :task_assignments

  # Validations
  validates :task_name, presence: true
  validates :status, inclusion: { in: %w(Completed Incomplete), message: "%{value} is not a valid status" }
end
  