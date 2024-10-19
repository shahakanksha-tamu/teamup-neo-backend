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

When("I click on the student dropdown") do
     puts "Current URL: #{current_path}" # Debugging line to print the current URL
    find(".student-select").click  
    end

When("I select {string} from the student dropdown") do |student_email|
    puts "Student Email: #{student_email}"
    select student_email, from: 'user_id'
    selected_option = find('.student-select option[selected]')
    expect(selected_option.text).to eq(student_email)
  end

When("I click Add Student") do
  user_id = find(".student-select").value # Get the selected user's ID from the dropdown
  puts "UserId #{user_id}"
  button = find("#add-student", data: { user_id: user_id }) # Find the button with the specific data attribute
  button.click
end

Then('I click on the Team Management') do
  click_button('Team Management')
end
  
Then("I should see a success message {string}") do |message|
  expect(page).to have_content(message)
end

When("I click on the remove button for {string}") do |student_email|
  # Find the list of students within the user-list-group class
  within(".user-list-group") do
    # Print each list item for debugging purposes
    all("li").each do |li|
      puts "List Item: #{li.text}"  # Output the text content of each <li>
    end

    # Now try to find the specific list item that contains the student's email
    within("li", text: "janesmith@gmail.com") do
      click_button "Remove"
    end
  end
end

Then("I should see the removal success message {string}") do |message|
  expect(page).to have_content(message)
end
