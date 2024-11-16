# frozen_string_literal: true

When('I navigate to the calendar page') do
  mock_google_calendar_api
  visit calendar_view_path
end

Then('I should see the calendar') do
  expect(page).to have_content('Calendar')
end

Then('I should be redirected to the login page') do
  visit(root_path)
end
