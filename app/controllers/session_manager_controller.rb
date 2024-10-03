# frozen_string_literal: true

# SessionManagerController is a common controller to handle session methods
class SessionManagerController < ApplicationController
  skip_before_action :require_login, only: %i[google_oauth_callback_handler google_oauth_failure_handler]

  def logout; end

  def login(user)
    if @user.present?
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'You are logged in.'
    else
      redirect_to root_path, alert: 'Login failed.'
    end
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
end
