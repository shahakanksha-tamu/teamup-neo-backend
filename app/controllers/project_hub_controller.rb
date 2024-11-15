# frozen_string_literal: true

# Handles all actions related to the Project Hub page.
class ProjectHubController < ApplicationController
  before_action :redirect_if_no_project

  def redirect_if_no_project
    @project = Project.joins(:student_assignments)
                      .where(student_assignments: { user_id: current_user.id })[0]
    render('shared/project_not_found') if @project.nil?
  end

  def index
    # sidebar requires the variables here
    @project = Project.joins(:student_assignments)
                      .where(student_assignments: { user_id: current_user.id })[0]
    @resources = @project.resources.includes(:file_attachment)
    @event = Event.where(show: true).first
    @show_sidebar = !@project.nil?
    @role = current_user.role
  end

  def view_tasks
    @show_sidebar = true

    @current_user_tasks = load_tasks

    @not_started_tasks = sorted_tasks('Not Started')
    @completed_tasks = sorted_tasks('Completed')
    @in_progress_tasks = sorted_tasks('In-Progress')
    @not_completed_tasks = sorted_tasks('Not Completed')

    @total_count = @not_started_tasks.count + @completed_tasks.count + @in_progress_tasks.count + @not_completed_tasks.count
  end

  def update_task_status
    @task = Task.find(params[:id])
    if @task.update(status: params[:status])
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'error', errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def timeline
    # Retrieve project for the current user
    @show_sidebar = true
    @project = Project.joins(:student_assignments)
                      .where(student_assignments: { user_id: current_user.id })
                      .first
    if @project
      @milestones = @project.milestones
      @milestones = @milestones.where(status: params[:status]) if params[:status].present?
    else
      @milestones = []
    end
  end

  def show_milestones
    @project = Project.joins(:student_assignments)
                      .where(student_assignments: { user_id: current_user.id })[0]
    @show_sidebar = !@project.nil?
    @role = current_user.role

    # Milestone retrieval and filtering logic
    if @project
      @milestones = @project.milestones
      @milestones = @milestones.where(status: params[:status]) if params[:status].present?
    else
      @milestones = []
    end
  end

  private

  def load_tasks
    Task.joins(:task_assignment, :milestone)
        .where(task_assignments: { user_id: current_user.id })
        .select('tasks.*, milestones.title, milestones.deadline as milestone_deadline, milestones.status as milestone_status')
        .group_by(&:status)
  end

  def sorted_tasks(status)
    (@current_user_tasks[status] || []).sort_by(&:milestone_id)
  end
end
