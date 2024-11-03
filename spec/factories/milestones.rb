# frozen_string_literal: true

# spec/factories/milestones.rb

FactoryBot.define do
  factory :milestone do
    association :project
    title { 'Sample Milestone' }
    start_date { Time.zone.today }
    deadline { Time.zone.today + 10.days }
    status { 'Not Started' }
    objective { 'This is a sample milestone description.' }
  end
end
