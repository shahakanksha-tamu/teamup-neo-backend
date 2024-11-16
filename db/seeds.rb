# frozen_string_literal: true

# Users
users = [
  { first_name: 'Akanksha', last_name: 'Shah', email: 'shahakanksha@tamu.edu', contact: '1234567890', role: 'admin' },
  { first_name: 'Rahaan', last_name: 'Gandhi', email: 'rahaan123@gmail.com', contact: '1234567891', role: 1 },
  { first_name: 'Rahaan', last_name: 'Gandhi', email: 'rahaang99@tamu.edu', contact: '1234567891', role: 0 },
  { first_name: 'Dhruva', last_name: 'Khanwelkar', email: 'dhruvak@tamu.edu', contact: '1234567892', role: 0 },
  { first_name: 'Meghana', last_name: 'Pradhan', email: 'meghna.pradhan@tamu.edu', contact: '1234567893', role: 0 },
  { first_name: 'Ramneek', last_name: 'Kaur', email: 'ramneek983@tamu.edu', contact: '1234567894', role: 0 },
  { first_name: 'Hao', last_name: 'Jin', email: 'q389974204@tamu.edu', contact: '1234567895', role: 0 },
  { first_name: 'Yiyang', last_name: 'Yan', email: 'yyy2000@tamu.edu', contact: '1234567896', role: 0 },
  { first_name: 'Phillip', last_name: 'Ritchey', email: 'pcr@tamu.edu', role: 0, contact: '1234567896' },
  { first_name: 'Anirith', last_name: '', email: 'anirith@tamu.edu', role: 0, contact: '1234567896' },
  { first_name: 'Florencia', last_name: 'Mangini', email: 'florencia.mangini@teamup.org', role: 'admin', contact: '1234567896' },
  { first_name: 'David', last_name: 'Kebo', email: 'davidkebo@tamu.edu', role: 'admin', contact: '1234567896' },
  { first_name: 'Shashankit', last_name: 'Thakur', email: 'shashankit.thakur@gmail.com', role: 'admin', contact: '1234567896' },
  { first_name: 'Akanksha', last_name: 'Shah', email: 'shahakanksha286@gmail.com', role: 'student', contact: '1234567896' },
  { first_name: 'Shashankit', last_name: 'Thakur', email: 'shashankit.t@gmail.com', role: 'student', contact: '1234567896' }

]

users.each do |user|
  User.find_or_create_by!(user)
end

# Projects
projects = [
  { name: 'Project Gamma', description: 'Third test project', objectives: 'Complete the gamma phase', status: 'active', start_date: Date.new(2024, 11, 1), end_date: Date.new(2026, 1, 1) },
  { name: 'Project Delta', description: 'Fourth test project', objectives: 'Complete the delta phase', status: 'active', start_date: Date.new(2024, 11, 1), end_date: Date.new(2026, 1, 1) },
  { name: 'Project Epsilon', description: 'Fifth test project', objectives: 'Complete the epsilon phase', status: 'active', start_date: Date.new(2024, 11, 1), end_date: Date.new(2026, 1, 1) }
]

projects.each do |project|
  Project.find_or_create_by!(project)
end

# Milestones for Project Gamma
milestones_gamma = [
  { title: 'Gamma Milestone 1', objective: 'Gamma milestone 1 objective', project_id: Project.find_by(name: 'Project Gamma').id, start_date: Date.new(2025, 9, 21), deadline: Date.new(2025, 9, 27), status: 'In-Progress' },
  { title: 'Gamma Milestone 2', objective: 'Gamma milestone 2 objective', project_id: Project.find_by(name: 'Project Gamma').id, start_date: Date.new(2025, 9, 27), deadline: Date.new(2025, 10, 3), status: 'Not Started' },
  { title: 'Gamma Milestone 3', objective: 'Gamma milestone 3 objective', project_id: Project.find_by(name: 'Project Gamma').id, start_date: Date.new(2025, 10, 3), deadline: Date.new(2025, 10, 8) }
]

milestones_gamma.each do |milestone|
  Milestone.find_or_create_by!(milestone)
end

# Milestones for Project Delta
milestones_delta = [
  { title: 'Delta Milestone 1', objective: 'Delta milestone 1 objective', project_id: Project.find_by(name: 'Project Delta').id, start_date: Date.new(2025, 9, 21), deadline: Date.new(2025, 9, 27), status: 'In-Progress' },
  { title: 'Delta Milestone 2', objective: 'Delta milestone 2 objective', project_id: Project.find_by(name: 'Project Delta').id, start_date: Date.new(2025, 9, 27), deadline: Date.new(2025, 10, 3), status: 'Not Started' },
  { title: 'Delta Milestone 3', objective: 'Delta milestone 3 objective', project_id: Project.find_by(name: 'Project Delta').id, start_date: Date.new(2025, 10, 3), deadline: Date.new(2025, 10, 8) }
]

milestones_delta.each do |milestone|
  Milestone.find_or_create_by!(milestone)
end

# Milestones for Project Epsilon
milestones_epsilon = [
  { title: 'Epsilon Milestone 1', objective: 'Epsilon milestone 1 objective', project_id: Project.find_by(name: 'Project Epsilon').id, start_date: Date.new(2025, 9, 21), deadline: Date.new(2025, 9, 27), status: 'In-Progress' },
  { title: 'Epsilon Milestone 2', objective: 'Epsilon milestone 2 objective', project_id: Project.find_by(name: 'Project Epsilon').id, start_date: Date.new(2025, 9, 27), deadline: Date.new(2025, 10, 3), status: 'Not Started' },
  { title: 'Epsilon Milestone 3', objective: 'Epsilon milestone 3 objective', project_id: Project.find_by(name: 'Project Epsilon').id, start_date: Date.new(2025, 10, 3), deadline: Date.new(2025, 10, 8) }
]

milestones_epsilon.each do |milestone|
  Milestone.find_or_create_by!(milestone)
end

# Tasks for Gamma Milestones
tasks_gamma = [
  { task_name: 'Gamma Milestone 1 Task 1', description: 'Description for Gamma Milestone 1 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 1').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Gamma Milestone 1 Task 2', description: 'Description for Gamma Milestone 1 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 1').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Gamma Milestone 1 Task 3', description: 'Description for Gamma Milestone 1 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 1').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Gamma Milestone 1 Task 4', description: 'Description for Gamma Milestone 1 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 1').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Gamma Milestone 1 Task 5', description: 'Description for Gamma Milestone 1 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 1').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Gamma Milestone 2 Task 1', description: 'Description for Gamma Milestone 2 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 2').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Gamma Milestone 2 Task 2', description: 'Description for Gamma Milestone 2 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 2').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Gamma Milestone 2 Task 3', description: 'Description for Gamma Milestone 2 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 2').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Gamma Milestone 2 Task 4', description: 'Description for Gamma Milestone 2 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 2').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Gamma Milestone 2 Task 5', description: 'Description for Gamma Milestone 2 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 2').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Gamma Milestone 3 Task 1', description: 'Description for Gamma Milestone 3 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 3').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Gamma Milestone 3 Task 2', description: 'Description for Gamma Milestone 3 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 3').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Gamma Milestone 3 Task 3', description: 'Description for Gamma Milestone 3 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 3').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Gamma Milestone 3 Task 4', description: 'Description for Gamma Milestone 3 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 3').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Gamma Milestone 3 Task 5', description: 'Description for Gamma Milestone 3 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Gamma Milestone 3').id, deadline: Time.zone.now + 5.days }
]

tasks_gamma.each do |task|
  Task.find_or_create_by!(task)
end

# Tasks for Delta Milestones
tasks_delta = [
  { task_name: 'Delta Milestone 1 Task 1', description: 'Description for Delta Milestone 1 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 1').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Delta Milestone 1 Task 2', description: 'Description for Delta Milestone 1 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 1').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Delta Milestone 1 Task 3', description: 'Description for Delta Milestone 1 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 1').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Delta Milestone 1 Task 4', description: 'Description for Delta Milestone 1 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 1').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Delta Milestone 1 Task 5', description: 'Description for Delta Milestone 1 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 1').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Delta Milestone 2 Task 1', description: 'Description for Delta Milestone 2 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 2').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Delta Milestone 2 Task 2', description: 'Description for Delta Milestone 2 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 2').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Delta Milestone 2 Task 3', description: 'Description for Delta Milestone 2 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 2').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Delta Milestone 2 Task 4', description: 'Description for Delta Milestone 2 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 2').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Delta Milestone 2 Task 5', description: 'Description for Delta Milestone 2 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 2').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Delta Milestone 3 Task 1', description: 'Description for Delta Milestone 3 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 3').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Delta Milestone 3 Task 2', description: 'Description for Delta Milestone 3 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 3').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Delta Milestone 3 Task 3', description: 'Description for Delta Milestone 3 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 3').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Delta Milestone 3 Task 4', description: 'Description for Delta Milestone 3 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 3').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Delta Milestone 3 Task 5', description: 'Description for Delta Milestone 3 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Delta Milestone 3').id, deadline: Time.zone.now + 5.days }
]

tasks_delta.each do |task|
  Task.find_or_create_by!(task)
end

# Tasks for Epsilon Milestones
tasks_epsilon = [
  { task_name: 'Epsilon Milestone 1 Task 1', description: 'Description for Epsilon Milestone 1 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 1').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Epsilon Milestone 1 Task 2', description: 'Description for Epsilon Milestone 1 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 1').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Epsilon Milestone 1 Task 3', description: 'Description for Epsilon Milestone 1 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 1').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Epsilon Milestone 1 Task 4', description: 'Description for Epsilon Milestone 1 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 1').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Epsilon Milestone 1 Task 5', description: 'Description for Epsilon Milestone 1 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 1').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Epsilon Milestone 2 Task 1', description: 'Description for Epsilon Milestone 2 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 2').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Epsilon Milestone 2 Task 2', description: 'Description for Epsilon Milestone 2 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 2').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Epsilon Milestone 2 Task 3', description: 'Description for Epsilon Milestone 2 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 2').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Epsilon Milestone 2 Task 4', description: 'Description for Epsilon Milestone 2 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 2').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Epsilon Milestone 2 Task 5', description: 'Description for Epsilon Milestone 2 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 2').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Epsilon Milestone 3 Task 1', description: 'Description for Epsilon Milestone 3 Task 1', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 3').id, deadline: Time.zone.now + 1.day },
  { task_name: 'Epsilon Milestone 3 Task 2', description: 'Description for Epsilon Milestone 3 Task 2', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 3').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Epsilon Milestone 3 Task 3', description: 'Description for Epsilon Milestone 3 Task 3', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 3').id, deadline: Time.zone.now + 3.days },
  { task_name: 'Epsilon Milestone 3 Task 4', description: 'Description for Epsilon Milestone 3 Task 4', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 3').id, deadline: Time.zone.now + 4.days },
  { task_name: 'Epsilon Milestone 3 Task 5', description: 'Description for Epsilon Milestone 3 Task 5', status: 'Not Started', milestone_id: Milestone.find_by(title: 'Epsilon Milestone 3').id, deadline: Time.zone.now + 5.days }
]

tasks_epsilon.each do |task|
  Task.find_or_create_by!(task)
end

# Student Assignments
student_assignments = [
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, project_id: Project.find_by(name: 'Project Gamma').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, project_id: Project.find_by(name: 'Project Gamma').id },
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, project_id: Project.find_by(name: 'Project Gamma').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, project_id: Project.find_by(name: 'Project Delta').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, project_id: Project.find_by(name: 'Project Epsilon').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, project_id: Project.find_by(name: 'Project Epsilon').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, project_id: Project.find_by(name: 'Project Delta').id }
]

student_assignments.each do |assignment|
  StudentAssignment.find_or_create_by!(assignment)
end

# Task Assignments
task_assignments = [
  # Project Gamma Assignments
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, task_id: Task.find_by(task_name: 'Gamma Milestone 1 Task 1').id },
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, task_id: Task.find_by(task_name: 'Gamma Milestone 2 Task 1').id },
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, task_id: Task.find_by(task_name: 'Gamma Milestone 3 Task 1').id },
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, task_id: Task.find_by(task_name: 'Gamma Milestone 1 Task 4').id },
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, task_id: Task.find_by(task_name: 'Gamma Milestone 2 Task 4').id },

  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 1 Task 2').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 2 Task 2').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 3 Task 2').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 1 Task 4').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 1 Task 5').id },

  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 1 Task 3').id },
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 2 Task 3').id },
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 3 Task 3').id },
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 3 Task 4').id },
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, task_id: Task.find_by(task_name: 'Gamma Milestone 3 Task 5').id },

  # Project Delta Assignments
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 1 Task 1').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 2 Task 1').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 3 Task 1').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 1 Task 4').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 2 Task 4').id },

  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 1 Task 2').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 2 Task 2').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 3 Task 2').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 1 Task 4').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 1 Task 5').id },

  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 1 Task 3').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 2 Task 3').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 3 Task 3').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 3 Task 4').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, task_id: Task.find_by(task_name: 'Delta Milestone 3 Task 5').id },

  # Project Epsilon Assignments
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 1 Task 1').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 2 Task 1').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 3 Task 1').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 1 Task 4').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 2 Task 4').id },

  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 1 Task 2').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 2 Task 2').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 3 Task 2').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 1 Task 4').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 1 Task 5').id },

  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 1 Task 3').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 2 Task 3').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 3 Task 3').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 3 Task 4').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, task_id: Task.find_by(task_name: 'Epsilon Milestone 3 Task 5').id }
]

task_assignments.each do |assignment|
  TaskAssignment.find_or_create_by!(assignment)
end

# Events seed data
events = [
  { title: 'Guest Lecture on Agile Development', description: 'Please join guest lecture on Wednesday at 5:30pm', show: true },
  { title: 'Complete Project Selection', description: 'All students must select their project by the deadline', show: false }
]

events.each do |event|
  Event.find_or_create_by!(event)
end
