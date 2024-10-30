# frozen_string_literal: true

Given('the following tasks exist for {string}') do |milestone_name, task_table|
  milestone = Milestone.find_by(title: milestone_name)
  puts milestone.status
  milestone_id = milestone.id
  task_table.hashes.each do |row|
    Task.create(task_name: row['name'], status: row['status'], deadline: row['deadline'], description: row['description'], milestone_id:)
  end
end

When('I click the {string} link') do |link_text|
  click_link(link_text)
end

Then('I should see a list of tasks {string}') do |list_of_tasks|
  tasks = list_of_tasks.tr('[]', '').split(',').map(&:strip)
  tasks.each do |task|
    expect(page).to have_content(task)
  end
end

When('I click on the {string} title') do |task_name|
  task_name_id = task_name.tr(' ', '-')
  find("##{task_name_id}", text: task_name, visible: :all, wait: 5).click
  expect(page).to have_selector('#taskModal', visible: true, wait: 5)
end

Then('I should not see the task {string}') do |task_name|
  expect(page).not_to have_content(task_name)
end

Then('I visit task management page for {string} project for Student {string}') do |project_name, email|
  project = Project.find_by(name: project_name)
  user = User.find_by(email:)

  visit(project_student_view_tasks_path(project, user))
end

Given('the following task assignments exists') do |task_assignment_table|
  task_assignment_table.hashes.each do |row|
    user_email = row['user_email']
    task_name = row['task_name']

    user_id = User.find_by(email: user_email).id
    task_id = Task.find_by(task_name:).id

    TaskAssignment.create(user_id:, task_id:)
  end
end

Then('I should see the details of task {string}') do |task_name|
  task = Task.find_by(task_name:)
  task_description = task.description
  task_status = task.status
  task_deadline = task.deadline

  expect(page).to have_content(task_name)
  expect(page).to have_content(task_status)
  expect(page).to have_content(task_description)
  expect(page).to have_content(task_deadline)
end

Then('I change the status of the {string} to {string}') do |task_name, new_status|
  Task.find_by(task_name:)
  find('#status-select').select new_status

  page.execute_script <<-JS
  const meta = document.createElement('meta');
  meta.name = "csrf-token";
  meta.content = "test-csrf-token";
  document.head.appendChild(meta);
  JS

  within('.select-div') do
    find('#save-status-btn', visible: true).click
  end
end

Then('the status of task {string} should be {string}') do |task_name, status|
  task_status = Task.find_by(task_name:).status
  expect(task_status).to eq(status)
end

Then('I visit project hub page') do
  visit(project_hub_path)
end