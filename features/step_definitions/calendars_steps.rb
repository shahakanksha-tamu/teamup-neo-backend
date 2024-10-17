# frozen_string_literal: true

When('I navigate to the calendar page') do
  visit calendar_view_path
end

Then('I should see the calendar') do
  expect(page).to have_content('Calendar') # Adjust to match your actual page content
end

Then('I should be redirected to the login page') do
  visit(dashboard_path)
end
