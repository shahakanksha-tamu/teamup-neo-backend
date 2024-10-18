# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    first_name { 'Joe' }
    last_name { 'Goldberg' }
    sequence(:email) { |n| "user#{n}@example.com" }  # Ensure unique emails
    role { :admin }  # Use the symbol for role
    contact { "1234567890" }  # Add contact if needed
    photo { "photo_url" }  # Add a default photo URL if applicable

    trait :instructor do
      role { :instructor }
    end
  end
end
