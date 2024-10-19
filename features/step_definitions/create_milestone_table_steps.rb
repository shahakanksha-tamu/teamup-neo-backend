# frozen_string_literal: true

Given('the following milestones exist for {string}') do |project_name, milestones_table|
  project = Project.find_by(name: project_name)
  milestones_table.hashes.each do |milestone|
    Milestone.create!(
      project:,
      title: milestone['title'],
      objective: milestone['objective'],
      deadline: milestone['deadline']
    )
  end
end
