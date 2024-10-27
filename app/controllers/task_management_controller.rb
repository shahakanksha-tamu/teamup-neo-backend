# frozen_string_literal: true

# Controller to handle all settings related functions
class TaskManagementController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @students = User.includes(task_assignments: :task)
    @show_sidebar = !@project.nil?
  end

  def create
    @student = User.find(params[:user_id])
    @task = @student.tasks.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'Task created successfully.'
    else
      render :index
    end
  end

  private

  def task_params
    params.require(:task).permit(:task_name, :status, :milestone_id)
  end
end
