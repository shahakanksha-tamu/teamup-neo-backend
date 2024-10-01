Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/logout", to: "session_manager#logout"
  get "/auth/google_oauth2/callback", to: "session_manager#google_ouath_callback_handler"

  # Defines the root path route ("/")
  root "landing_page#index"
end
