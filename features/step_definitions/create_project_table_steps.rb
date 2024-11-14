# frozen_string_literal: true

Given(/the following projects exist/) do |projects_table|
  projects_table.hashes.each do |project|
    Project.create!(name: project['name'], description: project['description'], objectives: project['objectives'], status: project['status'], end_date: Date.new(2025, 1, 1), start_date: Date.new(2024, 11, 1))
  end
end
