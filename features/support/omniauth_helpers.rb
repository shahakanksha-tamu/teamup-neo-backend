# features/support/omniauth_helpers.rb
module OmniAuthHelpers
  def mock_omniauth(provider, user_data)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(user_data)
  end

  def clear_omniauth_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end

World(OmniAuthHelpers)