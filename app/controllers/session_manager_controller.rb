# frozen_string_literal: true

# SessionManagerController is a common controller to handle session methods
class SessionManagerController < ApplicationController
  skip_before_action :require_login, only: %i[google_oauth_callback_handler google_oauth_failure_handler]

  def logout
    reset_session
    redirect_to root_path, notice: 'You are logged out.'
  rescue StandardError => e
    redirect_to dashboard_path, alert: "Failed to logout: #{e.message}"
  end

  def google_oauth_callback_handler
    auth = request.env['omniauth.auth']
    @user = User.find_by(email: auth['info']['email'], provider: auth['provider'])
    login @user
  end

  def google_oauth_failure_handler
    redirect_to root_path,
                alert: "Authentication failed: #{params[:message].humanize}"
  end

  private

  def login(user)
    if user.present?
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'You are logged in.'
    else
      redirect_to root_path, alert: 'Login failed.'
    end
  end
end
