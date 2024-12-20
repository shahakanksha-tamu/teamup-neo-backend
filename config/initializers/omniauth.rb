Rails.application.config.middleware.use OmniAuth::Builder do
  # Retrieve the Google credentials from Rails credentials
  google_credentials = Rails.application.credentials.google

  # Configure the Google OAuth provider with the client_id and client_secret
  provider :google_oauth2, google_credentials[:client_id], google_credentials[:client_secret], {
      scope: "email, profile, calendar", # This grants access to the user's email and profile information.
      prompt: "consent", # This allows users to choose the account they want to log in with.
      image_aspect_ratio: "square", # Ensures the profile picture is a square.
      image_size: 500, # Sets the profile picture size to 50x50 pixels.
      provider_ignores_state: true
    }
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
