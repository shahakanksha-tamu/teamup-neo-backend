# frozen_string_literal: true

  Given('the following projects exist') do |projects_table|
    projects_table.hashes.each do |project|
      Project.create!(project)
    end
  end
  
 
  When('I navigate to the project management page for {string}') do |project_name|
    project = Project.find_by(name: project_name)
    expect(project).not_to be_nil
    visit(project_management_hub_team_path(project.id))
  end
  
  Then('I shouldd see {string}') do |text|
    expect(page).to have_content(text)
  end
#   Given('I am on the Project Management Hub page for {string}') do |project_name|
#     project = Project.find_by(name: project_name)
#     expect(project).not_to be_nil
#     visit(project_management_hub_team_path(project.id)) # Ensure this matches your actual route
#   end
  
#   When("I select {string} from the dropdown") do |student_email|
#     select student_email, from: "user_email"
#   end
  
#   When("I click Add Student") do
#     click_button "Add Student"
#   end
#   Then('I should see a success message {string}') do |message|
#     expect(page).to have_content(message)
#   end
  
#   Then('{string} should be in the list of team members') do |email|
#     expect(page).to have_content(email)
#   end