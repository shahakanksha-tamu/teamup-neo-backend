# frozen_string_literal: true

Given('the given projects exists in the database') do |projects|
  projects.hashes.each do |row|
    Project.create!(
      name: row['name'],
      description: 'Default project description',
      objectives: 'Default project objectives',
      status: 'active'
    )
  end
end

Given(/the given student assignments exist/) do |student_assignment_table|
  student_assignment_table.hashes.each do |row|
    user_email = row['user_email']
    project_name = row['project_name']

    user_id = User.find_by(email: user_email).id
    project_id = Project.find_by(name: project_name).id

    StudentAssignment.create!(
      user_id:,
      project_id:
    )
  end
end

Given('I am logged in as {string}') do |email|
  visit(root_path)
  mock_omniauth(:google_oauth2, {
                  provider: 'google_oauth2',
                  uid: '123456789',
                  info: {
                    email:,
                    name: 'John Doe',
                    image: 'https://example.com/testuser.jpg'
                  },
                  credentials: {
                    token: 'mock_token',
                    refresh_token: 'mock_refresh_token',
                    expires_at: Time.zone.now + 1.week
                  }
                })
  click_button('Login with Google')
end

When('I visit team information page') do
  click_link('Team Members')
end

When('I visit project hub') do
  visit(dashboard_team_view_path)
end

When('I click Know Your Team button') do
  find('.view-team').click
end

Then('I should see mentor information') do
  mentors = User.where(role: 'admin')
  mentors.each do |mentor|
    expect(page).to have_content(mentor.first_name)
    expect(page).to have_content(mentor.last_name)
    expect(page).to have_content(mentor.email)
    expect(page).to have_content(mentor.role.titleize)
    expect(page).to have_content(mentor.contact)
  end
end

Then('I should other team members information for project {string} and not contact information for {string}') do |project_name, email|
  current_user_id = User.find_by(email:).id
  project = Project.find_by(name: project_name)
  puts "Project retrieved: #{project.inspect}"
  team_members_id = StudentAssignment.where(project_id: project.id).where.not(user_id: current_user_id).pluck(:user_id)
  team_members = User.where(id: team_members_id)

  team_members.each do |member|
    expect(page).to have_content(member.first_name)
    expect(page).to have_content(member.last_name)
    expect(page).to have_content(member.email)
    expect(page).to have_content(member.contact)
  end
end