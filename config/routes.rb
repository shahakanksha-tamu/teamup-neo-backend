# frozen_string_literal: true

Rails.application.routes.draw do
  resources :students
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'logout', to: 'session_manager#logout', as: :logout
  get '/auth/google_oauth2/callback', to: 'session_manager#google_oauth_callback_handler'
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/auth/failure', to: 'session_manager#google_oauth_failure_handler'
  # Defines the root path route ("/")
  root 'landing_page#index'
end
