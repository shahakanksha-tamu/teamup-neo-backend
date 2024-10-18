class Resource < ApplicationRecord
  belongs_to :project
  has_one_attached :file

  validates :name
  validates :file_or_link_attached

  def file_or_link_attached
    return unless file.attached? && link.present?

    raise_validation_error('Both file and link cannot be uploaded')
  end
end
