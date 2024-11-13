# frozen_string_literal: true

Then('I should be on the import data page') do
  expect(current_path).to eq(import_path)
end

Then('I visit import data page') do
  visit import_path
end


Then('I click on the delete button') do
  click_button('Delete All Data')
end

Then('I click upload button') do
  click_button('Upload and Import')
end

Then('I attach {string} to {string}') do |file_path, field_name|
  attach_file(field_name,Rails.root.join(file_path))
end
