# frozen_string_literal: true

# Handles all actions related to the Project Hub page.
class ProjectHubController < ApplicationController
  before_action :set_user_role

  def set_user_role
    @role = User.find(session[:user_id]).role
    redirect_to landing_page_path unless @role
    return unless @role == 'admin'

    redirect_to dashboard_path
  end

  def index
    @user = User.find(session[:user_id])
  end
end
