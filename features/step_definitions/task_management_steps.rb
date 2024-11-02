# features/step_definitions/task_steps.rb

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
  page.all('.card').each do |card|
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

# Given the following project exists in the database
Given('the following project exists in the database') do |projects|
  projects.hashes.each do |row|
    Project.create!(
      id: row['id'],
      name: row['name'],
      description: row['description'],
      objectives: row['objectives']
    )
  end
  puts Project.all.inspect
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
  puts Task.all.inspect
end

# Given the following milestones exist in the database
Given('the following milestones exist in the database') do |milestones|
  milestones.hashes.each do |row|
    Milestone.create!(
      project_id: row['project_id'],
      id: row['id'],
      title: row['title'],
      objective: row['objective'],
      deadline: row['deadline'] ? DateTime.parse(row['deadline']) : nil
    )
  end
  puts Milestone.all.inspect
end
