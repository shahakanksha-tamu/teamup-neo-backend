# frozen_string_literal: true

When('I navigate to the project management page for {string}') do |project_name|
  project = Project.find_by(name: project_name)
  expect(project).not_to be_nil
  visit(project_dashboard_path(project.id))
  expect(current_path).to eq(project_dashboard_path(project.id))
end

Then('I shouldd see {string}') do |text|
  expect(page).to have_content(text)
end

When('I click on the student dropdown') do
  puts "Current URL: #{current_path}" # Debugging line to print the current URL
  find('.student-select').click
end

When('I select {string} from the student dropdown') do |student_email|
  puts "Student Email: #{student_email}"
  select student_email, from: 'user_id'
  selected_option = find('.student-select option[selected]')
  expect(selected_option.text).to eq(student_email)
end

When('I click Add Student') do
  # user_id = find('.student-select').value # Get the selected user's ID from the dropdown
  # puts "UserId #{user_id}"
  # button = find('#add-student', data: { user_id: }) # Find the button with the specific data attribute
  button = find('#add-student')
  button.click
end

Then('I click on the Team Management') do
  click_link('Team Management')
end

Then('I click on the Resource Management') do
  click_link('Resource Management')
end

Then('I should see a success message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see the error message {string}') do |error_message|
  expect(page).to have_content(error_message)
end

When('I click on the remove button for {string}') do |_student_email|
  # Find the list of students within the user-list-group class
  within('.user-list-group') do
    # Print each list item for debugging purposes
    all('li').each do |li|
      puts "List Item: #{li.text}" # Output the text content of each <li>
    end

    # Now try to find the specific list item that contains the student's email
    within('li', text: 'janesmith@gmail.com') do
      click_button 'Remove'
    end
  end
end

Then('I should see the removal success message {string}') do |message|
  expect(page).to have_content(message)
end

Given('I fill in {string} with {string}') do |input, value|
  fill_in input, with: value
end

Then('I click on the {string} link') do |link_test|
  click_link(link_test)
end

When('I attach the file {string} to {string}') do |file_name, field_name|
  attach_file(field_name, File.absolute_path(file_name.to_s))
end

When('I click Create Resource') do
  click_button('Create Resource')
end

Then('I should be redirected to the resources page for {string}') do |project_name|
  project = Project.find_by(name: project_name)
  expect(project).not_to be_nil
  expect(current_path).to eq(project_resources_path(project.id))
end

When('I click on the Edit Project button') do
  # Find and click the Edit Project button in the dashboard
  find('.editButton').click
end

Then('I should see the Edit Project modal') do
  # Ensure the modal is visible after clicking the Edit button
  expect(page).to have_selector('#projectModal', visible: true)
end

When('I fill in the Edit Project form with the following:') do |table|
  # Fill in the modal form with the provided values
  data = table.rows_hash
  fill_in 'Name', with: data['Name']
  fill_in 'Description', with: data['Description']
  fill_in 'Objectives', with: data['Objectives']
  select data['Status'], from: 'Status'
end

When('I click Update Project') do
  # Submit the modal form
  find('input[name="commit"]').click
end

Then('the project should be updated successfully') do
  # Check for success message after form submission
  expect(page).to have_content('Project was successfully updated.')
end

Then('the progress chart should show {int}% complete') do |progress|
  # Check the progress percentage on the chart
  chart_canvas = find('#progressChart')
  actual_progress = chart_canvas['data-progress'].to_i
  expect(actual_progress).to eq(progress)
end

When('I fill in the Edit Project form with the following invalid:') do |table|
  data = table.rows_hash
  fill_in 'Name', with: data['Name']
  fill_in 'Description', with: data['Description']
  fill_in 'Objectives', with: data['Objectives']
  select data['Status'], from: 'Status'
end
When('I click Update Projectt') do
  # Submit the modal form
  find('input[name="commit"]').click
end

Then('I should see an error message {string}') do |error_message|
  expect(page).to have_content(error_message)
end

When('An unknown error would occur when adding the student') do
  allow_any_instance_of(Project).to receive(:add_student).and_return(false)
end

When('an unknown error would occur when removing the student') do
  allow_any_instance_of(Project).to receive(:remove_student).and_return(false)
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end

When('I click on the remove button for file {string}') do |file_name|
  within('table tbody') do
    within('tr', text: file_name) do
      click_button 'Remove'
    end
  end
end

When('An unknown error would occur when creating the resource') do
  allow_any_instance_of(Resource).to receive(:save).and_return(false)
end

When('I click on the Delete Project button') do
  find('.deleteButton').click
end
Then('I should see a confirmation dialog with message {string}') do |message|
  alert = page.driver.browser.switch_to.alert
  puts "Alert text: #{alert.text}"
  expect(alert.text).to eq(message)
rescue Selenium::WebDriver::Error::NoSuchAlertError
  raise 'No alert appeared when expected'
end

When('I confirm the deletionn') do
  page.driver.browser.switch_to.alert.accept
  puts 'Alert was successfully accepted.'
  puts current_path
rescue Selenium::WebDriver::Error::NoSuchAlertError
  raise 'No alert to accept, something went wrong.'
end
When('I cancel the deletionn') do
  page.driver.browser.switch_to.alert.dismiss
  puts 'Alert was successfully accepted.'
  puts current_path
rescue Selenium::WebDriver::Error::NoSuchAlertError
  raise 'No alert to accept, something went wrong.'
end

Then('I should be redirected to the project management hub page') do
  Capybara.default_max_wait_time = 10 # Increase to 10 seconds, adjust as needed
  expect(page).to have_current_path(project_management_hub_path)
end
Then('I should still be on the project management page for {string}') do |project_name|
  project = Project.find_by(name: project_name)
  expect(current_path).to eq(project_dashboard_path(project.id))
end
