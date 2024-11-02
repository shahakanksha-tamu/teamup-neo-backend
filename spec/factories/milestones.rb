FactoryBot.define do
  factory :milestone do
    title { 'Sample Milestone' }
    objective { 'Objective description' }
    deadline { '2024-12-01 10:00:00' }
    project
  end
end
