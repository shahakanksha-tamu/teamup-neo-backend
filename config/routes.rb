# frozen_string_literal: true

Rails.application.routes.draw do
  # Calendars route
  resources :resources
  get 'calendars', to: 'calendars#index', as: :calendar_view

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Session management routes
  get 'logout', to: 'session_manager#logout', as: :logout
  get '/auth/google_oauth2/callback', to: 'session_manager#google_oauth_callback_handler'
  get '/auth/failure', to: 'session_manager#google_oauth_failure_handler'

  # Dashboard routes
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/dashboard/team/view', to: 'team_info#index'

  # Project Hub routes
  get '/project_hub', to: 'project_hub#index', as: :project_hub

  # Project Management Hub routes
  get 'projects/:project_id/project_management_hub', to: 'project_management_hub#index', as: 'project_management_hub'
  get 'projects/:project_id/management_hub', to: 'project_management_hub#team', as: 'project_management_hub_team'
  post 'projects/:project_id/add_student', to: 'project_management_hub#add_student', as: 'add_student_to_project'
  delete 'projects/:project_id/remove_student', to: 'project_management_hub#remove_student', as: 'remove_student_from_project'

  # Settings route
  get '/settings', to: 'settings#index', as: :settings

  # Root path
  root 'landing_page#index'

  # Catch-all route for handling 404s
  match '*path', to: 'application#not_found', via: :all

  resources :projects do
    resources :resources, only: %i[new create index show]
  end
end
