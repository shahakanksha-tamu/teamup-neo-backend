# frozen_string_literal: true

Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create user
  end
end

Given('I am already registered to Neo application with email {string}') do |email|
  user = User.find_by(email:)
  expect(user).not_to be_nil
end

Given('I visit landing page') do
  visit(root_path)
end
When('I press Login with Google and choose {string} as my google account for authentication') do |email|
  mock_omniauth(:google_oauth2, {
    provider: 'google_oauth2',
    uid: '123456789',
    info: {
      email:,
      name: 'John Doe',
      image: 'https://example.com/testuser.jpg'
    },
    credentials: {
      token: 'mock_token',
      refresh_token: 'mock_refresh_token',
      expires_at: Time.zone.now + 1.week
    },
    extra: {
      raw_info: {
        calendars: [
          {
            id: 'primary',
            summary: 'Primary Calendar',
            description: 'My primary Google calendar',
            access_role: 'owner'
          },
          {
            id: 'secondary',
            summary: 'Secondary Calendar',
            description: 'My secondary Google calendar',
            access_role: 'editor'
          }
        ]
      }
    }
  })
  click_button('Login with Google')
end

Then('I should be signed in as {string}') do |email|
  user = User.find_by(email:)
  expect(user).not_to be_nil
  expect(current_path).to eq(project_hub_path)
end

Then('I should see {string} button') do |button_string|
  expect(page).to have_button(button_string)
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should be on the landing page') do
  expect(current_path).to eq(root_path)
end

Then('I should be on the project hub page') do
  expect(current_path).to eq(project_hub_path)
end

Then('I press {string}') do |button_string|
  click_button button_string
end

When('I cancel the Google OAuth consent') do
  mock_omniauth_failure(:google_oauth2)
end
