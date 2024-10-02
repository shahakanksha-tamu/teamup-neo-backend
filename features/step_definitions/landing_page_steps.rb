Given('I am a visitor') do
  end
  
  When('I visit the landing page') do
    visit root_path  
  end
  
  Then('I should see a heading {string}') do |heading_text|
    expect(page).to have_content(heading_text)
  end
  