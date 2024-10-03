# frozen_string_literal: true

# features/support/omniauth_helpers.rb
module OmniAuthHelpers
  def mock_omniauth(provider, user_data)
    clear_omniauth_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(user_data)
  end

  def clear_omniauth_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  def mock_omniauth_failure(provider)
    clear_omniauth_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
    visit '/auth/failure?message=user_denied_consent&strategy=google_oauth2'
  end
end

World(OmniAuthHelpers)
