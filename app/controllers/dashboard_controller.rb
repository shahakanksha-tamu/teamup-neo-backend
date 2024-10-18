# frozen_string_literal: true

# DashboardController handles all the methods/functions related to project dashboard
class DashboardController < ApplicationController
  def index
    @projects = Project.joins(:student_assignments)
                       .where(student_assignments: { user_id: current_user.id })
    #  .includes(:users, :milestones, :timeline)
  end
end
