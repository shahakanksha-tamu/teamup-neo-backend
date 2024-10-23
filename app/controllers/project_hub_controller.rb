# frozen_string_literal: true

# Handles all actions related to the Project Hub page.
class ProjectHubController < ApplicationController
  before_action :redirect_if_no_project

  def redirect_if_no_project
    @project = Project.joins(:student_assignments)
                      .where(student_assignments: { user_id: current_user.id })[0]
    redirect_to dashboard_path if @project.nil?
  end
  
  def index

    # sidebar requires the variables here
    @project = Project.joins(:student_assignments)
                       .where(student_assignments: { user_id: current_user.id })[0]
    @show_sidebar = !@project.nil?
    @role = current_user.role
  end
end
