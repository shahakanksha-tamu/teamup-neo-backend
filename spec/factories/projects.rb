# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    objectives { Faker::Lorem.sentences(number: 3).join("\n") }
    status { 'active' }

    transient do
      students_count { 0 }
    end

    after(:create) do |project, evaluator|
      create_list(:student_assignment, evaluator.students_count, project:)
    end
  end
end
