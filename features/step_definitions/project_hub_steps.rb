# frozen_string_literal: true

When('I click View Project') do
  click_link 'View Project'
end

When('I click {string} on the resource {string}') do |button_name, resource_name|
  within('.card', text: resource_name) do
    click_link button_name
  end
end

Then('I should see the file {string} downloaded') do |file_name|
  expect(File.exist?(file_name)).to be true
  # expect(page.response_headers['Content-Disposition']).to include('attachment')
end

Then('I should see the file {string} opened') do |_file_name|
  expect(page.response_headers['Content-Disposition']).to include('inline')
end

When('I click Task Management') do
  click_link('Task Management')
end
