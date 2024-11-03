# frozen_string_literal: true

# Model to handle resources
class Resource < ApplicationRecord
  belongs_to :project
  has_one_attached :file

  def can_be_displayed_inline?
    file.content_type.in?(config.active_storage.content_types_allowed_inline)
  end
end
