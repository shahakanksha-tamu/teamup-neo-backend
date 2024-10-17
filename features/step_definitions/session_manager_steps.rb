# frozen_string_literal: true

Given('I am logged in as a valid user') do
  @user = FactoryBot.create(:user, provider: 'google_oauth2', email: 'test@example.com')

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       provider: 'google_oauth2',
                                                                       uid: '123545',
                                                                       info: { email: @user.email }
                                                                     })

  visit '/auth/google_oauth2/callback'
end

When('an error occurs during logout') do
  allow_any_instance_of(SessionManagerController).to receive(:reset_session).and_raise(StandardError, 'Simulated logout error')
  visit logout_path
end

Then('I should be redirected to the dashboard') do
  expect(page).to have_current_path(dashboard_path)
end

Given('I am on the login page') do
  visit '/auth/google_oauth2'
end

When('I try to log in with invalid credentials') do
  OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
  visit '/auth/google_oauth2/callback'
end

Then('I should be redirected to the root path') do
  expect(page).to have_current_path(root_path)
end

Then('I should see an alert message Failed to logout: {string}') do |error_message|
  expect(page).to have_content("Failed to logout: #{error_message}")
end
