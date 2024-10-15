# frozen_string_literal: true

class Timeline < ApplicationRecord
  belongs_to :project
  has_many :milestones, dependent: :nullify

  # Validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return unless end_date < start_date

    errors.add(:end_date, 'must be after the start date')
  end
end
