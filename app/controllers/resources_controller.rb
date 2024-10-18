# frozen_string_literal: true

# Class to handle resources associated with projects
class ResourcesController < ApplicationController
  before_action :set_project

  def index
    @resources = @project.resources
  end

  def new
    @resource = @project.resources.new
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

  def resource_params
    params.require(:resource).permit(:name, :file)
  end
end
