# frozen_string_literal: true

class MilestonesController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_project
  before_action :set_milestone, only: %i[edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @show_sidebar = !@project.nil?

    # @milestones = Milestone.where(project_id: @project.id)
    @milestones = Milestone.includes(:tasks).where(project_id: params[:project_id])
    @milestone = @project.milestones.build # Initialize a new milestone for the form
  end

  def create
    @milestone = @project.milestones.build(milestone_params)
    if @milestone.deadline < 1.week.from_now
      flash[:alert] = 'Deadline must be at least one week from now.'
      @milestones = Milestone.where(project_id: @project.id)
      redirect_to project_milestones_path(@project) and return
    elsif @milestone.save
      redirect_to project_milestones_path(@project), notice: 'Milestone was successfully created.'
    else
      @milestones = @project.milestones.select(&:persisted?) # Only include saved milestones
      render :index
    end
  end

  def update
    if @milestone.update(milestone_params)
      redirect_to project_milestones_path(@project), notice: 'Milestone was updated successfully.'
    else
      render :edit
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @show_sidebar = !@project.nil?

    @milestones = @project.milestones # Ensure milestones are loaded for display
    render :index
  end

  def update_milestone_status
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:id])
    if @milestone.update(status: params[:milestone][:status])
      flash[:success] = 'Status updated successfully'
    else
      flash[:error] = 'Failed to update status'
    end
    redirect_to project_milestones_path(@project)
  end

  def destroy
    @milestone.destroy
    redirect_to project_milestones_path(@project), notice: 'Milestone was deleted successfully.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_milestone
    @milestone = @project.milestones.find(params[:id])
  end

  def milestone_params
    params.require(:milestone).permit(:title, :objective, :deadline)
  end
end
