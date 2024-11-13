# frozen_string_literal: true

# Milestone class describes the MVP tasks and its description
class Milestone < ApplicationRecord
  belongs_to :project

  validate :start_and_end_dates_within_project_dates
  validate :status_cannot_be_in_progress_before_start_date, on: :update

  has_many :tasks, dependent: :destroy
  has_many :task_assignments, through: :tasks, dependent: :destroy
  has_many :timelines, dependent: :destroy

  enum status: {
    'Not Started' => 'Not Started',
    'Completed' => 'Completed',
    'In-Progress' => 'In-Progress'
  }

  validates :status, presence: true
  validates :title, presence: true, uniqueness: { message: 'must be unique' }

  private

  def start_and_end_dates_within_project_dates
    if project.present?
      if start_date.present? && project.start_date.present? && (start_date < project.start_date || start_date > project.end_date)
        errors.add(:start_date, "must be within the project's start and end dates")
      end

      if deadline.present? && project.end_date.present? && (deadline < project.start_date || deadline > project.end_date)
        errors.add(:deadline, "must be within the project's start and end dates")
      end
    end
  end

  def status_cannot_be_in_progress_before_start_date
    if status == 'In-Progress' && start_date.present? && start_date > Date.today
      errors.add(:status, "cannot be 'In-Progress' before the start date")
    end
  end
end