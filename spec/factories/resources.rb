# frozen_string_literal: true

FactoryBot.define do
  factory :resource do
    name { 'Sample Resource' }
    file { Rack::Test::UploadedFile.new(Rails.root.join('sample.pdf'), 'application/pdf') }
    association :project
  end
end
