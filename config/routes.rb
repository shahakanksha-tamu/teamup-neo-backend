# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  # Calendars route
  resources :resources

  get 'calendars', to: 'calendars#calendars', as: :calendar_view
  get '/redirect', to: 'calendars#redirect', as: :calendar_redirect
  get '/callback', to: 'calendars#callback'

  resources :events do
    member do
      patch 'update_show', to: 'events#update_show'
    end
  end

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Session management routes
  get 'logout', to: 'session_manager#logout', as: :logout
  get '/auth/google_oauth2/callback', to: 'session_manager#google_oauth_callback_handler'
  get '/auth/failure', to: 'session_manager#google_oauth_failure_handler'

  # Import Data route
  get '/import/data/', to: 'import_data#index', as: :import
  delete '/import/data/delete', to: 'import_data#delete_data', as: :import_delete
  post '/import/data/upload', to: 'import_data#upload_data', as: :import_upload

  # Project Hub routes
  get '/project_hub', to: 'project_hub#index', as: :project_hub
  get '/project_management_hub', to: 'project_management_hub#index', as: :project_management_hub

  # Project Hub routes
  get 'view_score', to: 'score#index', as: :view_score
  patch 'update_score', to: 'score#update', as: :update_score

  resources :projects do # rubocop:disable Metrics/BlockLength
    get 'dashboard', to: 'project_management_hub#dashboard', as: 'dashboard'
    get 'team_management', to: 'project_management_hub#team', as: 'team_management'
    get 'task_management', to: 'task_management#index', as: 'task_management'
    post 'add_student', to: 'project_management_hub#add_student', as: 'add_student'
    delete 'remove_student', to: 'project_management_hub#remove_student', as: 'remove_student'

    # Student routes related to project
    get 'team', to: 'team_info#index', as: 'view_team'

    # Project
    get 'edit_project', to: 'project_management_hub#edit', as: 'edit_project'
    patch 'update_project', to: 'project_management_hub#update', as: 'update_project'

    # Students
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

    # Nested resources for resources management
    resources :resources, only: %i[new create index destroy] do
      member do
        get :download # This allows downloading a specific resource
        get :open
      end
    end

    # Nested resources for milestones management
    resources :milestones, only: %i[index create edit update destroy] do
      member do
        patch 'update_status', to: 'milestones#update_milestone_status', as: 'update_milestone_status'
      end
    end

    resources :users do
      resources :tasks, only: %i[create update destroy], controller: 'task_management'
    end
  end

  # Settings route
  get '/settings', to: 'settings#index', as: :settings

  post '/create_project', to: 'project_management_hub#create_project', as: :create_project

  # Defines the root path route ("/")
  root 'landing_page#index'

  # Score routes
  # get '/score/index', to: 'score#index', as: :view_score
  # patch '/score/update', to: 'score#update', as: :update_score

  # Event routes
  # resources :events
  # get '/events', to: 'event#index', as: :events
  # post '/events', to: 'event#create', as: :create_event
  # get '/events/:id/edit', to: 'event#edit', as: :edit_event
  # patch '/events/:id', to: 'event#update', as: :update_event
  # delete '/events/:id', to: 'event#destroy', as: :destroy_event

  # patch 'update_event', to: 'event#update', as: 'update_event'

  # Catch-all route for handling 404s
  match '*path', to: 'application#not_found', via: :all
end
