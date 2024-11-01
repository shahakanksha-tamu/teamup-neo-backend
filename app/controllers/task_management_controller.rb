# frozen_string_literal: true

# Controller to handle all settings related functions
class TaskManagementController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[update destroy]

  def index
    @students = @project.users.includes(task_assignments: :task)
    @show_sidebar = !@project.nil?
  end

  def create
    Rails.logger.debug "Params received: #{params.inspect}"
    @student = User.find(params[:user_id])
    @task = Task.new(task_params)

    if @task.save
      # Create the task assignment to associate the task with the student
      TaskAssignment.create(user_id: @student.id, task_id: @task.id)

      redirect_to project_task_management_path(@project)
    else
      # Debugging output to inspect errors and parameters
      Rails.logger.error "Task creation failed: #{@task.errors.full_messages.join(', ')}"
      Rails.logger.error "Parameters passed: #{task_params.inspect}"
      render :index
    end
  end

  def update
    if @task.update(task_params)
      redirect_to project_task_management_path(@project)
    else
      # Debugging output to inspect errors
      Rails.logger.error "Task update failed: #{@task.errors.full_messages.join(', ')}"
      render :index
    end
  end

  def destroy
    @task.destroy
    redirect_to project_task_management_path(@project)
  end

  private

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
