Given('the following student assignments exist for {string}') do |email, assignments_table|
  user = User.find_by(email:)
  assignments_table.hashes.each do |assignment|
    project = Project.find_by(name: assignment['project_name'])
    StudentAssignment.create!(user:, project:)
  end
end
