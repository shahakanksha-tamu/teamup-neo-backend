# frozen_string_literal: true

# Class to handle resources associated with projects
class ResourcesController < ApplicationController
  before_action :set_project
  before_action :set_resource, only: [:show]

  def index
    @resources = @project.resources
  end

  def new
    @resource = @project.resources.new
  end

  def show
  end

  def create
    @resource = @project.resources.new(resource_params)
    if @resource.save
      redirect_to project_resources_path(@project), notice: 'Resource was successfully created.'
    else
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_resource
    @resource = @project.resources.find(params[:id])
    # Optional: Handle not found case
    redirect_to project_resources_path(@project), alert: 'Resource not found.' if @resource.nil?
  end

  def resource_params
    params.require(:resource).permit(:name, :file)
  end
end
