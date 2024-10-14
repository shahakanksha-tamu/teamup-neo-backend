# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :student_assignments, dependent: :destroy
  has_many :users, through: :student_assignments
  has_many :milestones, dependent: :destroy
  has_one :timeline, dependent: :destroy
end
