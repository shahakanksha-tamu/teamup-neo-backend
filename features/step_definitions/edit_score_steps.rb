# frozen_string_literal: true

When('the admin visits the edit score page') do
  visit edit_score_path
end

When('I change score') do
  student = User.find_by(first_name: 'Jane')
  field_id = "students[#{student.id}][score]"
  fill_in field_id, with: 100
end
