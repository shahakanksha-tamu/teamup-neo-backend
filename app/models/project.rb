class Project < ApplicationRecord
  has_many :student_assignments
  has_many :users, through: :student_assignments
  has_many :milestones
  has_one :timelines
end

  