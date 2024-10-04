# frozen_string_literal: true

Given('I am logged in as user') do |user_table|
  user_data = user_table.hashes.first
  visit(root_path)

  mock_omniauth(:google_oauth2, {
                  provider: 'google_oauth2',
                  uid: '123456789',
                  info: {
                    email: user_data['email'],
                    name: "#{user_data['first_name']} #{user_data['last_name']}",
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

When('I click the {string} button') do |button_text|
  click_button button_text
end

When('I wait for the session to expire') do
  travel 8.weeks
end

When('I visit {string} directly') do |path|
  visit send("#{path}_path")
end

When('I encounter an error after clicking "Logout" button') do
  allow_any_instance_of(ActionDispatch::Request::Session).to receive(:[]).with(:user_id).and_raise(StandardError.new('Mock Error'))
  click_button 'Logout'
end
