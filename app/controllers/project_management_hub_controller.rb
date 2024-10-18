# frozen_string_literal: true

# Handles all functions related to the Project management hub page
class ProjectManagementHubController < ApplicationController
  def index
    @projects = Project.includes(:users, :timeline, milestones: :tasks)
  end
end
