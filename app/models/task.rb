class Task < ApplicationRecord
  belongs_to :milestone
  has_many :task_assignments
  has_many :users, through: :task_assignments
  enum status: {
    "Not Completed" => 'Not Completed',
    "Completed" => 'Completed',
    "Delayed" => 'Delayed'
  }

  # Validations
  validates :task_name, presence: true
  validates :status, presence: true
end
  