# frozen_string_literal: true

# Class to handle resources associated with projects
class ResourcesController < ApplicationController
  before_action :set_project
  before_action :set_resource, only: %i[download destroy]

  def index
    @project = Project.find(params[:project_id])
    @resources = @project.resources.includes(:file_attachment)
    @resource = @project.resources.new
    @show_sidebar = true
  end

  def new
    @resource = @project.resources.new
    @show_sidebar = true
  end

  def download
    # @resource = Resource.find(params[:id])
    send_data @resource.file.download, filename: @resource.file.filename.to_s, type: @resource.file.content_type, disposition: 'attachment'
  end

  def destroy
    @project = Project.find(params[:project_id]) # Assuming you're using nested resources
    @resource = @project.resources.find(params[:id]) # Find the resource

    if @resource.file.attached?
      @resource.file.purge # This removes the attached file from Active Storage
    end

    @resource.destroy # This removes the resource record from the database

    flash[:success] = 'Resource was successfully removed.'
    redirect_to project_resources_path(@project)
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
