# frozen_string_literal: true

class User < ApplicationRecord
  enum :role, { student: 0, admin: 1 }
end
