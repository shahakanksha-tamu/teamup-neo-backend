# frozen_string_literal: true

class Milestone < ApplicationRecord
  belongs_to :project
  has_many :tasks, dependent: :destroy
end
