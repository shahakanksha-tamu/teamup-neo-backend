# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Joe' }
    last_name { 'Goldberg' }
    email { 'joegoldberg@tamu.edu' }
    role { :student }
  end
end
