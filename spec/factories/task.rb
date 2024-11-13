# frozen_string_literal: true

# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    task_name { 'Sample Task' }
    status { 'Not Started' }
    deadline { '2024-12-15 10:00:00' }
    description { 'This is a sample task description' }
    association :milestone # assuming `task` belongs to a `milestone`
  end
end
