# frozen_string_literal: true

# Milestone class describes the MVP tasks and its description
class Milestone < ApplicationRecord
  belongs_to :project
  has_many :tasks, dependent: :destroy
end
