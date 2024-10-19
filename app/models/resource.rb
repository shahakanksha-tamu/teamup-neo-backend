# frozen_string_literal: true

# Model to handle resources
class Resource < ApplicationRecord
  belongs_to :project
  has_one_attached :file
end
