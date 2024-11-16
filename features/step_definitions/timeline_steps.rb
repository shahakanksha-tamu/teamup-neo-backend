# frozen_string_literal: true

# features/step_definitions/timeline_steps.rb
When('I navigate to the project timeline page') do
  visit project_student_timeline_path(@project, @user)
end

Given('I am on the project timeline page') do
  step 'I am a logged-in user with an assigned project'
  step 'I navigate to the project timeline page'
end

Then('I should see detailed information for that milestone') do
  milestone = @project.milestones.first
  expect(page).to have_content(milestone.objective)
end
