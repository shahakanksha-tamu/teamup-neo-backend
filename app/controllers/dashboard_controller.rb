# frozen_string_literal: true

# DashboardController handles all the methods/functions related to project dashboard
class DashboardController < ApplicationController
  before_action :set_user_role

  def set_user_role
    @role = User.find(session[:user_id]).role
    return if @role

    redirect_to landing_page_path
  end

  def index
    @user = User.find(session[:user_id])
  end
end
