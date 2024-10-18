# frozen_string_literal: true

# Project class contains all the details of the project, including timeline and list of milestones
class Project < ApplicationRecord
  has_many :student_assignments, dependent: :destroy
  has_many :users, through: :student_assignments
  has_many :milestones, dependent: :destroy
  has_one :timeline, dependent: :destroy
end
