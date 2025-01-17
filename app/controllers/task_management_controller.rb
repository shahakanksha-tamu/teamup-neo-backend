# frozen_string_literal: true

# Controller to handle all settings related functions
class TaskManagementController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[update destroy]

  def index
    @students = @project.users.includes(task_assignments: :task)
    @show_sidebar = !@project.nil?
    @completion_percentages = {}

    @students.each do |student|
      completed_tasks = student.tasks.where(status: 'Completed').count
      total_tasks = student.tasks.count
      @completion_percentages[student.id] = total_tasks.zero? ? 0 : (completed_tasks.to_f / total_tasks * 100).round(3)
    end
  end

  def create
    Rails.logger.debug "Params received: #{params.inspect}"
    @student = User.find(params[:user_id])
    @task = Task.new(task_params)

    if @task.deadline && @task.milestone && @task.deadline > @task.milestone.deadline
      flash[:alert] = "Deadline cannot be greater than the milestone's deadline."
      redirect_to project_task_management_path(@project) and return
    end

    if @task.save

      # Create the task assignment to associate the task with the student
      TaskAssignment.create(user_id: @student.id, task_id: @task.id)
    else
      flash[:error] = @task.errors.full_messages.to_sentence

    end
    redirect_to project_task_management_path(@project)
  end

  def update
    if task_params[:deadline] && @task.milestone && task_params[:deadline].to_date > @task.milestone.deadline
      flash[:alert] = "Deadline cannot be greater than the milestone's deadline."
      redirect_to project_task_management_path(@project) and return
    end
    return unless @task.update(task_params)

    redirect_to project_task_management_path(@project)
  end

  def destroy
    @task.destroy
    redirect_to project_task_management_path(@project)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :status, :milestone_id, :deadline, :description)
  end
end
