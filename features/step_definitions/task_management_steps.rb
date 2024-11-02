# frozen_string_literal: true

Given('the following projects exist in the database') do |projects|
  projects.hashes.each do |row|
    Project.create!(
      name: row['name'],
      description: 'Default project description',
      objectives: 'Default project objectives',
      status: 'active'
    )
  end
end

Given('the following project exists') do |projects|
  projects.hashes.each do |row|
    Project.create!(
      id: row['id'],
      name: row['name'],
      description: row['description'],
      objectives: row['objectives']
    )
  end
end

Given('the following tasks exist') do |tasks|
  tasks.hashes.each do |row|
    Task.create!(
      milestone_id: row['milestone_id'],
      task_name: row['task_name'],
      description: row['description'],
      status: row['status'],
      deadline: DateTime.parse(row['deadline'])
    )
  end
end

Given('the following milestones exist') do |milestones|
  milestones.hashes.each do |row|
    Milestone.create!(
      project_id: row['project_id'],
      title: row['title'],
      objective: row['objective'],
      deadline: row['deadline'] ? DateTime.parse(row['deadline']) : nil
    )
  end
end

Given(/there are students with tasks assigned/) do |task_assignment_table|
  task_assignment_table.hashes.each do |row|
    user_email = row['user_email']
    task_name = row['task_name']

    user_id = User.find_by(email: user_email).id
    task_id = Task.find_by(task_name:).id

    TaskAssignment.create!(
      user_id:,
      task_id:
    )
  end
end

When('I visit the task board page') do
  project = Project.find_by(id: 1)
  visit(project_task_management_path(project))
end

Then('I should see a card for each student') do
  puts @students.inspect

  expect(page).to have_content('John')
  expect(page).to have_content('Mariam')
end

Then('each card should display the student’s tasks with task details') do
  page.all('.card').find_each do |card|
    within(card) do
      expect(page).to have_content('Task 1')
      expect(page).to have_content('Not started')
    end
  end
end

When('I click on "Add Task" for {string}') do |student_name|
  puts "Trying to click 'Add Task' for #{student_name}"
  save_and_open_page

  within('.student-card', text: student_name) do
    click_button('Add Task')
  end
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |value, dropdown|
  select value, from: dropdown
end

When('I press {string}') do |button|
  click_button button
end

Then('I should see {string} in {string}\'s tasks') do |task_name, student_name|
  within("//div[contains(@class, 'student-card') and .//h4[text()='#{student_name}']]") do
    expect(page).to have_content(task_name)
  end
end

Then('the status should be {string}') do |status|
  expect(page).to have_content(status)
end
