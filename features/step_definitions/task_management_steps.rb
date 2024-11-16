# frozen_string_literal: true

# features/step_definitions/task_steps.rb

# Given the following project exists in the database
Given('the following project exists in the database') do |projects|
  projects.hashes.each do |row|
    start_date = if row['start_date'].nil?
                   Time.zone.now
                 else
                   DateTime.parse(row['start_date'])
                 end
    end_date = if row['end_date'].nil?
                 Time.zone.now + 30.days
               else
                 DateTime.parse(row['end_date'])
               end
    Project.create!(
      id: row['id'],
      name: row['name'],
      description: row['description'],
      objectives: row['objectives'],
      start_date:,
      end_date:
    )
  end
end

# Given the following tasks exist in the database
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

# Given the following milestones exist in the database
Given('the following milestones exist in the database') do |milestones|
  milestones.hashes.each do |row|
    Milestone.create!(
      project_id: row['project_id'],
      id: row['id'],
      title: row['title'],
      objective: row['objective'],
      start_date: row['start_date'] ? DateTime.parse(row['start_date']) : Project.find(row['project_id']).start_date,
      deadline: row['deadline'] ? DateTime.parse(row['deadline']) : Project.find(row['project_id']).end_date
    )
  end
end

# Given there are students with tasks assigned
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
    User.all.find_each do |user|
      puts user.tasks
    end
  end
end

Given('there exists a task named {string}') do |task_name|
  project = Project.find_by(id: 1)
  visit(project_task_management_path(project))
  @task = Task.find_by(task_name:)
  expect(@task).not_to be_nil
end

When('I change the task details') do |table|
  task_details = table.hashes.first
  @updated_task_name = task_details['task_name']
  @updated_description = task_details['description']
  @updated_milestone = task_details['milestone']
  @updated_deadline = task_details['deadline']
  @updated_status = task_details['status']

  within("#editTaskModal#{@task.id}") do
    fill_in 'task_task_name', with: @updated_task_name
    fill_in 'task_description', with: @updated_description
    select @updated_milestone, from: 'task[milestone_id]'
    fill_in 'task_deadline', with: @updated_deadline
    select  @updated_status, from: 'task_status'
  end
end

When('I click on "Update Task"') do
  within("#editTaskModal#{@task.id}") do
    click_button 'Update Task'
  end
end

# When I visit the task board page
When('I visit the task board page') do
  project = Project.find_by(id: 1)
  visit(project_task_management_path(project))
end

# Then I should see a card for each student
Then('I should see a card for each student') do
  expect(page).to have_content('John')
  expect(page).to have_content('Mariam')
end

# Then each card should display the student’s tasks with task details
Then('each card should display the student’s tasks with task details') do
  page.all('.card').find_each do |card|
    within(card) do
      expect(page).to have_content('Not started')
    end
  end
end

# When I click on "Add Task" for {string}
When('I click on "Add Task" for {string}') do |student_name|
  id = User.find_by(first_name: student_name).id
  within("##{id}") do
    click_button('Add Task')
  end
end

# When I select {string} from {string}
When('I select {string} from {string}') do |value, dropdown|
  select value, from: dropdown
end

# Then I should see {string} in {string}’s tasks
Then('I should see {string} in {string}’s tasks') do |task_name, student_name|
  within("//div[contains(@class, 'student-card') and .//h4[text()='#{student_name}']]") do
    expect(page).to have_content(task_name)
  end
end

# Then the status should be {string}
Then('the status should be {string}') do |status|
  expect(page).to have_content(status)
end

# When I fill in the task details
When('I fill in the task details') do |table|
  task_data = table.hashes.first

  within('#addTaskModal1') do
    # Fill in fields using their correct IDs or names
    fill_in 'task_task_name', with: task_data['task_name'] # Task Name
    fill_in 'task_description', with: task_data['description'] # Description (assuming you have this field)

    # Selecting a milestone from the dropdown
    select task_data['milestone'], from: 'task[milestone_id]' # Milestone selection

    fill_in 'task_deadline', with: task_data['deadline']

    # Select the status from the dropdown
    select task_data['status'], from: 'task_status'
  end
end

# When I submit the form
When('I submit the form') do
  within('#addTaskModal1') do
    click_button 'Create Task'
  end
end

When('I click on the name of {string} for {string}') do |task_name, student_name|
  id = User.find_by(first_name: student_name).id
  puts page.html
  within("##{id}") do
    # Scope to the card body
    within('.card-body') do
      # Scope to the specific task card
      within('.task-card') do
        # Find the h6 link with the specific task name and click it
        find('h6', text: task_name, visible: true).click
      end
    end
  end
end

# Then I should see the task {string} under {string} on the task board
Then('I should see the task {string} under {string} on the task board') do |task_name, student_name|
  within('.student-card', text: student_name) do
    expect(page).to have_content(task_name)
  end
end

# Given there is a student named {string} with a task {string} assigned
Given('there is a student named {string} with a task {string} assigned') do |student_name, task_name|
  student = User.create(first_name: student_name, email: 'alice@tamu.edu', role: 0)
  milestone = Milestone.create(title: 'Milestone 1')
  Task.create!(task_name:, description: 'Sample Description', milestone:, start_date: Date.parse('2023-10-25'), end_date: Date.parse('2023-11-01'), status: 'Not Completed', user: student)
end

# Then I should see {string} under {string} with the correct details
Then('I should see {string} under {string} with the correct details') do |task_name, student_name, table|
  within('.student-card', text: student_name) do
    expect(page).to have_content(task_name)
    table.rows_hash.each_value do |value|
      expect(page).to have_content(value)
    end
  end
end

Then('I should see a flash alert {string}') do |message|
  expect(page).to have_selector('.alert', text: message)
end

When(/^I delete the task "(.*?)"$/) do |task_name|
  # Find the task by name
  task = Task.find_by(task_name:)
  project = Project.find_by(id: 1)
  visit(project_task_management_path(project))

  find(".delete-icon[data-task-id='#{task.id}']").click
end

Then(/^I should not see the task "(.*?)" on the task management page$/) do |task_name|
  # Check that the task is no longer visible on the page
  expect(page).not_to have_content(task_name)
end

Then('the task should be deleted from the database') do
  # Find the task in the database after the delete action
  task = Task.find_by(id: @task.id)

  # Assert that the task is no longer in the database
  expect(task).to be_nil
end

Given('{string} has completed {int} out of {int} tasks') do |student_name, completed_tasks, _total_tasks|
  @student = User.find_by(email: student_name.downcase.delete(' ').concat('@gmail.com').to_s)

  completed_tasks.times do |i|
    status = 'Completed'
    task = Task.create(task_name: "Completed Task #{i + 1}", milestone_id: 1, status:, description: 'Completed task description', deadline: Date.parse('2023-10-25'))
    TaskAssignment.create(user: @student, task:)
  end
end

Then('I should see {string} with a completion percentage of {string}') do |student_name, expected_percentage|
  student = User.find_by(email: student_name.downcase.delete(' ').concat('@gmail.com').to_s)
  completed_tasks = student.tasks.where(status: 'Completed').count
  total_tasks = student.tasks.count
  completion_percentage = total_tasks.zero? ? 0 : (completed_tasks.to_f / total_tasks * 100)

  formatted_percentage = format('%.0f', completion_percentage)

  expect(formatted_percentage).to eq(expected_percentage)
end
