# frozen_string_literal: true

# Given the following events exist in the database
Given('the following events exist in the database') do |events|
  events.hashes.each do |row|
    Event.create!(
      id: row['id'],
      title: row['title'],
      description: row['description'],
      show: row['show']
    )
  end
end

When('I visit the Project Hub') do
  visit project_hub_path
end

Then('I should see the {string} event') do |event_name|
  expect(page).to have_content(event_name)
end

When('I visit the Events page') do
  visit events_path
end

Then('I should see {string} in the list of events') do |event_name|
  within('#events_list') do
    expect(page).to have_content(event_name)
  end
end

Then('I see the event {string}') do |event_name|
  within('#events_list') do
    expect(page).to have_content(event_name)
  end
end

Then('{string} should be broadcasted') do |event_name|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    expect(find_field('Broadcast Event')).to be_checked
  end
end

Then('{string} should not be broadcasted') do |event_name|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    expect(find_field('Broadcast Event')).not_to be_checked
  end
end

When('I click the {string} button for the event {string}') do |button, event_name|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    click_link_or_button button
  end
end

When('I confirm the deletion') do
  page.driver.browser.switch_to.alert.accept
end

Then('I should not see {string} in the list of events') do |event_name|
  within('#events_list') do
    expect(page).not_to have_content(event_name)
  end
end

When('I toggle the broadcast checkbox for the event {string} to true') do |event_name|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    check 'Broadcast Event'
  end
end

When('I toggle the broadcast checkbox for the event {string} to false') do |event_name|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    uncheck 'Broadcast Event'
  end
end

Then('I should see the event {string} with show set to {string}') do |event_name, show_status|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    checkbox = find_field('Broadcast Event')
    if show_status == 'true'
      expect(checkbox).to be_checked
    else
      expect(checkbox).not_to be_checked
    end
  end
end

And('I see the event {string} with show set to {string}') do |event_name, show_status|
  within(:xpath, "//li[contains(.,'#{event_name}')]") do
    checkbox = find_field('Broadcast Event')
    if show_status == 'true'
      expect(checkbox).to be_checked
    else
      expect(checkbox).not_to be_checked
    end
  end
end

When('I clear the {string} field') do |field|
  fill_in field, with: ''
end

Then('I should see {string} on the page') do |error_message|
  expect(page).to have_content(error_message)
end

Then('I should still see {string} in the list of events') do |event_name|
  within('#events_list') do
    expect(page).to have_content(event_name)
  end
end

When('I attempt to update the event with invalid data') do
  # Find the event instance
  Event.find_by(title: 'Kickoff Meeting')

  # Stub the update method to simulate a failure
  allow_any_instance_of(Event).to receive(:update).and_return(false)

  # Fill in the form with invalid data and submit
  fill_in 'Title', with: ''
  fill_in 'Description', with: ''
  click_button 'Update Event'
end

And('the session does not include an event') do
  page.execute_script("sessionStorage.removeItem('event_1');")
end

And('the session includes the event') do
  page.execute_script("sessionStorage.setItem('event_1', true);")
end

Then('I should not see the {string} event') do |event_name|
  expect(page).not_to have_content(event_name)
end