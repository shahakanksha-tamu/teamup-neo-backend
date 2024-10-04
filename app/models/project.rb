class Project < ApplicationRecord
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :students
end
