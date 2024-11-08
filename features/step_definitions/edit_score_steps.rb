When('the admin visits the edit score page') do
  visit edit_score_path
end

When('I change score for {string}') do |student_fname|
  student = User.find_by(first_name: student_fname)
  field_id = "students[#{student.id}][score]"
  fill_in field_id, with: 100
end
