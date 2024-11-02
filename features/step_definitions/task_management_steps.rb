# frozen_string_literal: true

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

  within('.student-card', text: student_name) do
    click_button('Add Task')
  end
end

# When('I fill in {string} with {string}') do |field, value|
#   fill_in field, with: value
# end

When('I select {string} from {string}') do |value, dropdown|
  select value, from: dropdown
end

# When('I press {string}') do |button|
#   click_button button
# end

Then('I should see {string} in {string}\'s tasks') do |task_name, student_name|
  within("//div[contains(@class, 'student-card') and .//h4[text()='#{student_name}']]") do
    expect(page).to have_content(task_name)
  end
end

Then('the status should be {string}') do |status|
  expect(page).to have_content(status)
end

When('I open the {string} form for {string}') do |form_name, student_name|
  find('.student-card', text: student_name).click_button form_name
end

When('I fill in the task details') do |table|
  task_data = table.hashes.first
  fill_in 'Task Name', with: task_data['task_name']
  fill_in 'Description', with: task_data['description']
  select task_data['milestone'], from: 'Milestone'
  fill_in 'Start Date', with: task_data['start_date']
  fill_in 'End Date', with: task_data['end_date']
  select task_data['status'], from: 'Status'
end

When('I submit the form') do
  click_button 'Create Task'
end

Then('I should see the task {string} under {string} on the task board') do |task_name, student_name|
  within('.student-card', text: student_name) do
    expect(page).to have_content(task_name)
  end
end

Given('there is a student named {string} with a task {string} assigned') do |student_name, task_name|
  student = User.create(first_name: student_name, email: 'alice@tamu.edu', role: 0)
  milestone = Milestone.create(title: 'Milestone 1')
  Task.create(task_name:, description: 'Sample Description', milestone:, start_date: Date.parse('2023-10-25'), end_date: Date.parse('2023-11-01'), status: 'Not Completed', user: student)
end

Then('I should see {string} under {string} with the correct details') do |task_name, student_name, table|
  within('.student-card', text: student_name) do
    expect(page).to have_content(task_name)
    table.rows_hash.each_value do |value|
      expect(page).to have_content(value)
    end
  end
end

Given('the following project exists in the database') do |projects|
  projects.hashes.each do |row|
    Project.create!(
      id: row['id'],
      name: row['name'],
      description: row['description'],
      objectives: row['objectives']
    )
  end
end

Given('the following tasks exist in the database') do |tasks|
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

Given('the following milestones exist in the database') do |milestones|
  milestones.hashes.each do |row|
    Milestone.create!(
      milest
      project_id: row['project_id'],
      title: row['title'],
      objective: row['objective'],
      deadline: row['deadline'] ? DateTime.parse(row['deadline']) : nil
    )
  end
end
