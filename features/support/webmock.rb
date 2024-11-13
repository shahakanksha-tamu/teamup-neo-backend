# features/support/webmock.rb

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

# Mock Google Calendar API response
def mock_google_calendar_api
  stub_request(:get, 'https://www.googleapis.com/calendar/v3/users/me/calendarList')
    .to_return(
      status: 200,
      body: {
        items: [
          { id: 'primary', summary: 'Primary Calendar' },
          { id: 'work', summary: 'Work Calendar' }
        ]
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end

# Mock Google OAuth token refresh response
def mock_google_token_refresh
  stub_request(:post, 'https://oauth2.googleapis.com/token')
    .with(
      body: hash_including({
        'grant_type' => 'refresh_token',
        'refresh_token' => 'mock_refresh_token'
      })
    )
    .to_return(
      status: 200,
      body: {
        access_token: 'new_mock_access_token',
        token_type: 'Bearer',
        expires_in: 3600
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end

# Setup mocks before each scenario tagged with @calendar
Before('@calendar') do
  mock_google_calendar_api
  mock_google_token_refresh
end
