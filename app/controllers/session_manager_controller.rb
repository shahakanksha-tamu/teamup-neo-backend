# frozen_string_literal: true

# SessionManagerController is a common controller to handle session methods
class SessionManagerController < ApplicationController
  skip_before_action :require_login, only: %i[google_oauth_callback_handler google_oauth_failure_handler]

  def logout
    reset_session
    redirect_to root_path, notice: 'You are logged out.'
  end

  def google_oauth_callback_handler
    auth = request.env['omniauth.auth']
    
    @user = User.find_by(email: auth['info']['email'], provider: auth['provider'])
    
    if @user.present?
      session[:user_id] = @user.id
      
      # Store OAuth tokens in the session for later use with Google APIs
      session[:authorization] = {
        token: auth['credentials']['token'],
        refresh_token: auth['credentials']['refresh_token'],
        expires_at: auth['credentials']['expires_at']
      }
      
      # Update user profile picture if necessary
      unless @user.photo?
        @user.update(photo: auth['info']['image'])
      end
      
      # Redirect user based on their role
      if @user.role == 'student'
        redirect_to project_hub_path, notice: 'You are logged in.'
      else
        redirect_to project_management_hub_path, notice: 'You are logged in.'
      end
    else
      # Handle case where user is not found
      redirect_to root_path, alert: 'Login failed.'
    end
  end
  
  def google_oauth_failure_handler
    redirect_to root_path,
                alert: "Authentication failed: #{params[:message].humanize}"
  end

  private

  def login(user, photo)
    if user.present?
      session[:user_id] = user.id
      unless user.photo?
        user.photo = photo
        user.save
      end

      if user.role == 'student'
        redirect_to dashboard_path, notice: 'You are logged in.'
      else
        redirect_to project_management_hub_path, notice: 'You are logged in.'
      end
    else
      redirect_to root_path, alert: 'Login failed.'
    end
  end
end