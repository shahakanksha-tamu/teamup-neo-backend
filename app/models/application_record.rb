# frozen_string_literal: true

# ApplicationRecord is the base class for all models in the application.
# It inherits from ActiveRecord::Base, and allows for shared functionality across models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
