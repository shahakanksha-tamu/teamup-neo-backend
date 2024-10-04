
Given(/the (.*) is logged in with "(.*)"/) do |user, email|
    visit(root_path)
    mock_omniauth(:google_oauth2, {
    provider: 'google_oauth2',
    uid: '123456789',
    info: {
      email: email,
      name: "John Doe",
      image: 'https://example.com/testuser.jpg'
    },
    credentials: {
      token: 'mock_token',
      refresh_token: 'mock_refresh_token',
      expires_at: Time.now + 1.week
    }
  })
  click_button("Login with Google")
end

When(/the (.*) navigates to the (.*)/) do |user, path|
    visit(path)
end

Then(/the (.*) should be directed to the (.*)/) do |user, path|
    expect(current_path).to eq("/"+path)
end

Then(/the (.*) should see the 404 page/) do |user|
    expect(page).to have_content("404")
end

And(/the (.*) should see "(.*)"/) do |user,text|
   expect(page).to have_content(text)
end