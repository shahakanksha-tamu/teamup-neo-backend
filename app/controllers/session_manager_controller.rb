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
      
      session[:authorization] = {
        token: auth['credentials']['token'],
        refresh_token: auth['credentials']['refresh_token'],
        expires_at: auth['credentials']['expires_at']
      }
      
      unless @user.photo?
        @user.update(photo: auth['info']['image'])
      end
      
      if @user.role == 'student'
        redirect_to dashboard_path, notice: 'You are logged in.'
      else
        redirect_to project_management_hub_path, notice: 'You are logged in.'
      end
    else
      redirect_to root_path, alert: 'Login failed.'
    end
  end
  
  def google_oauth_failure_handler
    redirect_to root_path,
                alert: "Authentication failed: #{params[:message].humanize}"
  end

  private

  # original method with high cognitive complexity
  # def login(user, photo)
  #   if user.present?
  #     session[:user_id] = user.id
  #     unless user.photo?
  #       user.photo = photo
  #       user.save
  #     end

  #     if user.role == 'student'
  #       redirect_to dashboard_path, notice: 'You are logged in.'
  #     else
  #       redirect_to project_management_hub_path, notice: 'You are logged in.'
  #     end
  #   else
  #     redirect_to root_path, alert: 'Login failed.'
  #   end
  # end

  def login(user, photo)
    if user.present?
      set_session(user)
      update_user_photo(user, photo)
      redirect_user(user)
    else
      redirect_to root_path, alert: 'Login failed.'
    end
  end

  def set_session(user) # rubocop:disable Naming/AccessorMethodName
    session[:user_id] = user.id
  end

  def update_user_photo(user, photo)
    return if user.photo?

    user.photo = photo
    user.save
  end

  def redirect_user(user)
    if user.role == 'student'
      redirect_to project_hub_path, notice: 'You are logged in.'
    else
      redirect_to project_management_hub_path, notice: 'You are logged in.'
    end
  end
end
