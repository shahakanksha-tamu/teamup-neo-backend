# frozen_string_literal: true

# ApplicationController acts as a base class for all the controllers
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :require_login
  before_action -> { restrict_access_based_on_role }

  private

  def role_based_routes
    {
      admin: [
        { controller: 'project_management_hub', action: 'index' },
        { controller: 'score', action: 'edit' },
        { controller: 'score', action: 'update' }
      ],
      student: [
        { controller: 'dashboard', action: 'index' },
        { controller: 'project_hub', action: 'index' },
        { controller: 'team_info', action: 'index' }
      ]
    }
  end

  def restrict_access_based_on_role
    return unless current_user

    user_role = current_user.role.to_sym
    controller_action = { controller: params[:controller], action: params[:action] }

    restricted_roles = role_based_routes.keys - [user_role]

    return unless restricted_roles.any? { |role| role_based_routes[role].include?(controller_action) }

    if user_role == :student
      redirect_to dashboard_path, alert: 'You are not authorized to access this page.'
    else
      redirect_to project_management_hub_path, alert: 'You are not authorized to access this page.'
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def require_login
    if logged_in?
      set_user_role
      return logged_in?
    end

    redirect_to root_path, alert: 'You must be logged in to access the resource.'
  end

  def set_user_role
    @user = User.find_by(id: session[:user_id])
    @role = @user.role
  end
end
