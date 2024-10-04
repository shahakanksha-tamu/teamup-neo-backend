Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "logout", to: "session_manager#logout", as: :logout
  get "/auth/google_oauth2/callback", to: "session_manager#google_oauth_callback_handler"
  get "/dashboard", to: "dashboard#index", as: :dashboard
  get "/project_hub", to: "project_hub#index", as: :project_hub
  get "/project_management_hub", to: "project_management_hub#index", as: :project_management_hub
  get "/settings", to: "settings#index", as: :settings
  # Defines the root path route ("/")
  root "landing_page#index"
  match "*path", to: "application#not_found", via: :all
end
