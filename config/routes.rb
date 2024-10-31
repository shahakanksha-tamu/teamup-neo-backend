# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
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

  # Project Hub routes
  get '/project_hub', to: 'project_hub#index', as: :project_hub
  get '/project_management_hub', to: 'project_management_hub#index', as: :project_management_hub

  # Project Hub routes
  resources :projects do
    get 'dashboard', to: 'project_management_hub#dashboard', as: 'dashboard'
    get 'team_management', to: 'project_management_hub#team', as: 'team_management'
    post 'add_student', to: 'project_management_hub#add_student', as: 'add_student'
    delete 'remove_student', to: 'project_management_hub#remove_student', as: 'remove_student'

    # Student routes related to project
    get 'team', to: 'team_info#index', as: 'view_team'

    resources :students, only: %i[show] do
      get 'tasks', to: 'project_hub#view_tasks', as: 'view_tasks'
      get 'show_milestones', to: 'project_hub#show_milestones', as: :show_milestones
      get 'timeline', to: 'project_hub#timeline', as: 'timeline'
      resources :tasks, only: %i[update] do
        member do
          patch 'update_status', to: 'project_hub#update_task_status', as: 'update_task_status'
        end
      end
    end
    # New edit and update routes for project management
    get 'edit_project', to: 'project_management_hub#edit', as: 'edit_project'
    patch 'update_project', to: 'project_management_hub#update', as: 'update_project'
    # Task management for project
    get 'tasks', to: 'project_hub#view_tasks', as: 'view_tasks'

    # Nested resources for resources management
    resources :resources, only: %i[new create index destroy] do
      member do
        get :download # This allows downloading a specific resource
      end
    end
  end

  # Settings route
  get '/settings', to: 'settings#index', as: :settings

  post '/create_project', to: 'project_management_hub#create_project', as: :create_project

  # Defines the root path route ("/")
  root 'landing_page#index'

  # Catch-all route for handling 404s
  match '*path', to: 'application#not_found', via: :all
end
