# frozen_string_literal: true

# Handles all actions related to the Project Hub page.
class ProjectHubController < ApplicationController
  def index
    @project = Project.joins(:student_assignments)
                      .where(student_assignments: { user_id: current_user.id })[0]
    @show_sidebar = true
    @role = current_user.role
  end
end
