
When 'I visit the Milestone Management Page' do 
  project = Project.find_by(id: 1)
  visit(project_milestones_path(project))
end

Then "I should see a card for each milestone" do
  expect(page).to have_content('Complete initial setup')
  expect(page).to have_content('Develop core features')
  expect(page).to have_content('Conduct testing and review')
end

Given "I am on the Milestone Management page" do
  project = Project.find_by(id: 1)
  visit(project_milestones_path(project))
end

# Then "I should see {string}" do |content|
#   expect(page).to have_content(content)
# end

When 'I create a new milestone with the title {string}, objective {string}, and deadline {string}' do |title, objective, deadline|

  fill_in 'milestone_title', with: title
  fill_in 'milestone_objective', with: objective
  
  # Split the deadline into year, month, and day components
  year, month, day = deadline.split('-')
  select year, from: 'milestone_deadline_1i'
  select Date::MONTHNAMES[month.to_i], from: 'milestone_deadline_2i'
  select day.to_i, from: 'milestone_deadline_3i'

  click_button 'Create Milestone'
end

Then 'I should see the milestone {string} in the list of milestones' do |title|
  expect(page).to have_content(title)
end

Given 'I see a milestone with the title {string} and objective {string}' do |title, objective|
  expect(page).to have_content(title)
  expect(page).to have_content(objective)
end

When 'I click the edit button for the milestone {string}' do |title|
  within(:xpath, "//li[contains(.,'#{title}')]") do
    click_link 'Edit'
  end
end

Then 'the title field should contain {string}' do |title|
  expect(find_field('milestone_title').value).to eq title
end

Then 'the objective field should contain {string}' do |objective|
  expect(find_field('milestone_objective').value).to eq objective
end

Then 'the deadline field should be set to {string}' do |deadline|
  year, month, day = deadline.split('-')
  
  # Check each part of the deadline separately
  expect(find_field('milestone_deadline_1i').value).to eq year
  expect(find_field('milestone_deadline_2i').value).to eq month.to_i.to_s  # Converting month to integer to avoid leading zero issues
  expect(find_field('milestone_deadline_3i').value).to eq day.to_i.to_s    # Same for the day
end


When 'I update the objective to {string}' do |new_objective|
  fill_in 'milestone_objective', with: new_objective
end

When 'I click {string}' do |button_text|
  click_button button_text
end

Then 'I should see the milestone {string} with objective {string} in the list of milestones' do |title, objective|
  within('#milestones_list') do
    expect(page).to have_content(title)
    expect(page).to have_content(objective)
  end
end

Given 'I see a milestone with the title {string}' do |title|
  expect(page).to have_content(title)
end

When 'I click the delete button for the milestone {string}' do |title|
  # Locate the specific milestone card and click the delete button within it
  # within(:xpath, "//li[contains(.,'#{title}')]") do
  #   accept_confirm 'Are you sure you want to delete' do
  #     click_button 'Delete'
  #   end
  # end
  within(:xpath, "//li[contains(.,'#{title}')]") do
    accept_confirm do
      click_button 'Delete'
    end
  end 
end

# When 'I confirm the deletion' do
#   # This will handle any JavaScript confirm dialog that appears
#   accept_confirm
# end

Then 'I should not see {string} in the list of milestones' do |title|
  expect(page).not_to have_content(title)
end


# When 'I click the update status button for the milestone {string}' do |title|
#   within(:xpath, "//li[contains(.,'#{title}')]") do
#     click_button 'Update Status'
#   end
# end

# When 'I select {string} from the status dropdown' do |status|
#   within('.modal-content', visible: true) do
#     select status, from: 'milestone_status'
#   end
# end
# 
When 'I click the update status button for the milestone {string}' do |title|
  within(:xpath, "//li[contains(.,'#{title}')]") do
    click_button 'Update Status'
  end
  @current_modal_id = "statusModal-#{1}"
end

When 'I select {string} from the status dropdown' do |status|
  within("##{@current_modal_id}") do
    select status, from: 'milestone_status'
  end
end

When 'I click {string} in the modal' do |button_text|
  within("##{@current_modal_id}") do
    click_button button_text
  end
end

Then 'I should see the status {string} displayed for {string}' do |status, title|
  within(:xpath, "//li[contains(.,'#{title}')]") do
    expect(page).to have_content(status)
  end
end

When 'I close the modal' do
  within("##{@current_modal_id}") do
    find('button.btn-close').click
  end
end

Then 'the modal should not be visible' do
  expect(page).not_to have_selector("##{@current_modal_id}", visible: true)
end

When 'I click the show tasks button for the milestone {string}' do |title|
  within(:xpath, "//li[contains(.,'#{title}')]") do
    click_button 'Show Tasks'
  end
  
  @current_tasks_modal = "tasksModal-#{1}"
  # Capture the specific modal ID or class if needed
end

Then 'I should see the task {string} with status {string}' do |task_name, status|
  within("##{@current_tasks_modal}") do
    expect(page).to have_content(task_name)
    expect(page).to have_content(status)
  end
end
