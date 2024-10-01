class SessionManagerController < ApplicationController
  skip_before_action :require_login, only: [ :google_oauth_callback_handler ]

  def logout
    # TODO:
    # 1) Reset the session
    # 2) Redirect to the landing page with flash message
  end

  def login(user)
    session[:user_id] = user.id
    redirect_to dashboard_path, notice: "You are logged in."
  end

  def google_oauth_callback_handler
    auth = request.env["omniauth.auth"]

    @user = User.find_by(email: auth["info"]["email"], provider: auth["provider"])
    if @user.present?
      login @user
    else
      redirect_to root_path, alert: "Login failed."
    end
  end
end
