Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "logout", to: "session_manager#logout", as: :logout
  get "/auth/google_oauth2/callback", to: "session_manager#google_oauth_callback_handler"
  get "/dashboard", to: "dashboard#index", as: :dashboard
  # Defines the root path route ("/")
  root "landing_page#index"
end
