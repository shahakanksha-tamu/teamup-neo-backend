FactoryBot.define do
  factory :resource do
    name { 'Sample Resource' }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/sample_file.pdf'), 'application/pdf') }
    association :project
  end
end
