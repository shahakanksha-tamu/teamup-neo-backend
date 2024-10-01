Given(/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create user
  end
end

Given('I am already registered to Neo application with email {string}') do |email|
  user = User.find_by(email: email)
  expect(user).not_to be_nil
end

Given("I visit landing page") do
  visit(root_path)
end

When("I press Login with Google and choose {string} as my google account for authentication") do |email|

  mock_omniauth(:google_oauth2, {
    provider: 'google_oauth2',
    uid: '123456789',
    info: {
      email: email,
      name: "John Doe",
      image: 'https://example.com/testuser.jpg'
    },
    credentials: {
      token: 'mock_token',
      refresh_token: 'mock_refresh_token',
      expires_at: Time.now + 1.week
    }
  })
  click_button("Login with Google")
end

Then("Then I should be signed in as {string}") do |email|
  user = User.find_by(email: email)
  expect(user).not_to be_nil
  expect(current_path).to eq(dashboard_path)
end

Then("I should see {string} button") do |button_string|
  expect(page).to have_button(button_string)
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should be on the landing page") do 
  expect(current_path).to eq(root_path)
end

Then('I should be on the dashboard page') do
  expect(current_path).to eq(dashboard_path)
end




