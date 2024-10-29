# frozen_string_literal: true

# Handles all functions related to the Project management hub page
class ProjectManagementHubController < ApplicationController
  before_action :set_project, except: %w[index create_project]

  def index
    @projects = Project.includes(:users, :timeline, milestones: :tasks)
  end

  def dashboard
    @project = Project.find(params[:project_id])
    @show_sidebar = !@project.nil?
    @progress = @project.progress 
  end

  def create_project
    @project = Project.new(project_params)
  
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless @project.save
  
      begin
        create_timeline(@project)
        create_student_assignments(@project, params[:user_ids])
      rescue ActiveRecord::RecordInvalid => e
        @project.errors.add(:base, "Error in associated data: #{e.message}")
        raise ActiveRecord::Rollback
      end
  
      if @project.errors.empty?
        redirect_to project_management_hub_path, notice: 'Project was successfully created.' and return
      end
    end
  
    # Transaction was rolled back
    error_message = @project.errors.full_messages.join(', ')
    redirect_to project_management_hub_path, alert: error_message and return
  end
  

  def project_params
    params.permit(:name, :description, :objectives, :status)
  end
  def project_params2
    params.require(:project).permit(:name, :description, :objectives, :status)
  end

  def create_timeline(project)
    timeline = project.build_timeline(
      start_date: params[:start_date],
      end_date: params[:end_date]
    )
    return if timeline.save

    project.errors.add(:timeline, timeline.errors.full_messages.join(', '))
    raise ActiveRecord::RecordInvalid, timeline
  end

  def create_student_assignments(project, user_ids)
    return if user_ids.blank?

    user_ids.reject(&:blank?).each do |user_id|
      user = User.find_by(id: user_id.to_i)
      if user
        assignment = project.student_assignments.build(user:)
        assignment.save
      else
        project.errors.add(:student_assignments, "User not found for id: #{user_id}")
        raise ActiveRecord::RecordInvalid, project
      end
    end
  end

  def team
    @project = Project.find(params[:project_id])
    @show_sidebar = !@project.nil?
  end

  def update
    @project = Project.find(params[:project_id])
    
    if @project.update(project_params2)
      redirect_to project_dashboard_path(@project), notice: 'Project was successfully updated.'
    else
      flash[:alert] = @project.errors.full_messages.to_sentence
       redirect_to project_dashboard_path(@project), notice: 'Unable to update the project'
    end
  end

  def add_student
    Rails.logger.debug("Params: #{params.inspect}")
    user = User.find(params[:user_id])
    if Project.joins(:student_assignments).where(student_assignments: { user_id: user.id }).exists?
      flash[:error] = "#{user.email} is already assigned to a project."
    elsif @project.add_student(user)
      flash[:success] = "#{user.email} was successfully added to the team."
    else
      flash[:error] = 'Failed to add student to the team.'
    end
    redirect_to project_team_management_path(@project)
  end

  def remove_student
    user = User.find(params[:user_id])
    if @project.remove_student(user)
      flash[:success] = "#{user.email} was successfully removed from the team."
    else
      flash[:error] = "Failed to remove #{user.email} from the team."
    end
    redirect_to project_team_management_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
