# frozen_string_literal: true

Given(/the (.*) is logged in with "(.*)"/) do |_user, email|
  visit(root_path)
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
                  }
                })
  click_button('Login with Google')
end

When(/the (.*) navigates to the (.*)/) do |_user, path|
  visit(path)
end

Then(/the (.*) should be directed to the (.*)/) do |_user, path|
  expect(current_path).to eq("/#{path}")
end

Then(/the (.*) should see the 404 page/) do |_user|
  expect(page).to have_content('404')
end

Then(/the (.*) should see "(.*)"/) do |_user, text|
  expect(page).to have_content(text)
end
