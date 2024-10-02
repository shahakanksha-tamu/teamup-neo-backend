Given('I am a visitor') do
  end
  
  When('I visit the landing page') do
    visit root_path  
  end
  
  Then('I should see {string} in the title') do |title_text|
    expect(page).to have_title(title_text)
  end
  
  Then('I should see a heading {string}') do |heading_text|
    expect(page).to have_content(heading_text)
  end
  
  Then('the background should have a gradient color') do
    expect(page).to have_css('body', style: { background: /linear-gradient/ })
  end
  