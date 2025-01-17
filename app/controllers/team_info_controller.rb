# frozen_string_literal: true

# TeamInfoController displays team member information and key contacts
class TeamInfoController < ApplicationController
  def index
    current_user_id = @user.id
    student_assignment = StudentAssignment.find_by(user_id: current_user_id)
    @team_members = []
    @project_name = ''

    unless student_assignment.nil?
      project_id = student_assignment.project_id
      other_users_id = StudentAssignment.where(project_id:).where.not(user_id: current_user_id).pluck(:user_id)
      @team_members = User.where(id: other_users_id)
      @project_name = Project.find_by(id: project_id).name
    end

    @mentors = fetch_all_mentors

    # sidebar requires the variables here
    @project = Project.find_by(id: project_id)
    @show_sidebar = !@project.nil?
  end

  private

  def fetch_all_mentors
    User.where(role: 'admin')
  end
end
