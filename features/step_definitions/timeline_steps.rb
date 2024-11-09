# frozen_string_literal: true

# features/step_definitions/timeline_steps.rb
When('I navigate to the project timeline page') do
  visit project_student_timeline_path(@project, @user)
end

Then('I should see a Gantt chart displaying project milestones') do
  expect(page).to have_css('.gantt-chart-container')

  @project.milestones.each do |milestone|
    expect(page).to have_content(milestone.title)
    expect(page).to have_content(milestone.start_date.strftime('%B %d, %Y'))
    expect(page).to have_content(milestone.deadline.strftime('%B %d, %Y'))
  end
end

Given('I am on the project timeline page') do
  step 'I am a logged-in user with an assigned project'
  step 'I navigate to the project timeline page'
end

When('I expand a milestone on the Gantt chart') do
  @project.milestones.first
end

Then('I should see detailed information for that milestone') do
  milestone = @project.milestones.first
  expect(page).to have_content(milestone.objective)
end
