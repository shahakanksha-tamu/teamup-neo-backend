# frozen_string_literal: true

# Handles all functions related to the Project management hub page
class ProjectManagementHubController < ApplicationController
  before_action :set_project, only: [:add_student, :remove_student]
  def index
    # This action will render an empty view
    @project = Project.find(params[:project_id])
  end
  def team
    @project = Project.find(params[:project_id])
    # Other logic to load the project and its students...
  end

  # Adding a student to a project (team)
  def add_student
    user = User.find(params[:user_id])
    if @project.add_student(user)
      flash[:success] = "#{user.email} was successfully added to the team."
    else
      flash[:error] = "Failed to add #{user.name} to the team."
    end
    redirect_to project_management_hub_team_path(@project)
  end

  # Removing a student from a project (team)
  def remove_student
    user = User.find(params[:user_id])
    if @project.remove_student(user)
      flash[:success] = "#{user.email} was successfully removed from the team."
    else
      flash[:error] = "Failed to remove #{user.email} from the team."
    end
    redirect_to project_management_hub_team_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end