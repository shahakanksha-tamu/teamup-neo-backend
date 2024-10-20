# frozen_string_literal: true

# Users
users = [
  { first_name: 'Akanksha', last_name: 'Shah', email: 'shahakanksha@tamu.edu', contact: '1234567890', role: 'admin' },
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
  { name: 'Project Alpha', description: 'First test project', objectives: 'Complete the alpha phase', status: 'active' },
  { name: 'Project Beta', description: 'Second test project', objectives: 'Complete the beta phase', status: 'inactive' }
]

projects.each do |project|
  Project.find_or_create_by!(project)
end

# Milestones
milestones = [
  { title: 'Alpha Milestone 1', objective: 'Complete initial setup', project_id: Project.find_by(name: 'Project Alpha').id, deadline: Time.zone.now + 7.days },
  { title: 'Beta Milestone 1', objective: 'Beta phase completion', project_id: Project.find_by(name: 'Project Beta').id, deadline: Time.zone.now + 14.days }
]

milestones.each do |milestone|
  Milestone.find_or_create_by!(milestone)
end

# Tasks
tasks = [
  { task_name: 'Setup project environment', description: 'Setup Rails environment', status: 'Not Completed', milestone_id: Milestone.find_by(title: 'Alpha Milestone 1').id, deadline: Time.zone.now + 2.days },
  { task_name: 'Implement database', description: 'Design and implement the database schema', status: 'Not Completed', milestone_id: Milestone.find_by(title: 'Beta Milestone 1').id, deadline: Time.zone.now + 5.days },
  { task_name: 'Final testing', description: 'Test all features', status: 'Not Completed', milestone_id: Milestone.find_by(title: 'Beta Milestone 1').id, deadline: Time.zone.now + 10.days }
]

tasks.each do |task|
  Task.find_or_create_by!(task)
end

# Student Assignments (Link users to projects)
student_assignments = [
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, project_id: Project.find_by(name: 'Project Alpha').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, project_id: Project.find_by(name: 'Project Alpha').id },
  { user_id: User.find_by(email: 'shahakanksha286@gmail.com').id, project_id: Project.find_by(name: 'Project Alpha').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, project_id: Project.find_by(name: 'Project Beta').id },
  { user_id: User.find_by(email: 'ramneek983@tamu.edu').id, project_id: Project.find_by(name: 'Project Beta').id },
  { user_id: User.find_by(email: 'q389974204@tamu.edu').id, project_id: Project.find_by(name: 'Project Beta').id },
  { user_id: User.find_by(email: 'yyy2000@tamu.edu').id, project_id: Project.find_by(name: 'Project Alpha').id }
]

student_assignments.each do |assignment|
  StudentAssignment.find_or_create_by!(assignment)
end

# Task Assignments (Link users to tasks)
task_assignments = [
  { user_id: User.find_by(email: 'rahaang99@tamu.edu').id, task_id: Task.find_by(task_name: 'Setup project environment').id },
  { user_id: User.find_by(email: 'dhruvak@tamu.edu').id, task_id: Task.find_by(task_name: 'Implement database').id },
  { user_id: User.find_by(email: 'meghna.pradhan@tamu.edu').id, task_id: Task.find_by(task_name: 'Final testing').id }
]

task_assignments.each do |assignment|
  TaskAssignment.find_or_create_by!(assignment)
end
