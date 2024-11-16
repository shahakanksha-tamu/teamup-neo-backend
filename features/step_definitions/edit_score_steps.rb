# frozen_string_literal: true

When('the admin visits the score page of {string}') do |project_name|
  # visit view_score_path
  project = Project.find_by(name: project_name)
  visit view_score_path(project.id)
end

When('the admin changes score for {string}') do |student_name|
  first_name, last_name = student_name.split(' ', 2)
  student = User.find_by(first_name:, last_name:)
  student_card = find('h4.card-title', text: student_name).ancestor('.card')

  within(student_card) do
    fill_in "students[#{student.id}][score]", with: 85
    click_button 'Update Score'
  end
end
