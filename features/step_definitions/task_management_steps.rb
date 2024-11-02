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
      expect(page).to have_content('Status: Not Completed')
    end
  end
end

Given('a student named {string} exists') do |name|
  @student = User.create(first_name: name, email: 'alice@tamu.edu', role: 0)
end

When('I open the {string} form for {string}') do |form_name, student_name|
  User.find_by(first_name: student_name)
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
