# frozen_string_literal: true

# Handles all functions related to the Project management hub page
class ProjectManagementHubController < ApplicationController
  def index
    @project = Project.new
  end


  def create_project
    @project = Project.new(project_params)
    
    ActiveRecord::Base.transaction do
      if @project.save
        begin
          create_timeline(@project)
          create_student_assignments(@project, params[:project][:user_ids])
        rescue ActiveRecord::RecordInvalid => e
          @project.errors.add(:base, "Error in associated data: #{e.message}")
          raise ActiveRecord::Rollback
        end
        
        if @project.errors.empty?
          redirect_to project_management_hub_path, notice: 'Project was successfully created.' and return
        end
      else
        # Project failed to save due to validation errors
        raise ActiveRecord::Rollback
      end
    end

    # If we've reached this point, the transaction has been rolled back
    error_message = if @project.errors.any?
                       @project.errors.full_messages.join(", ")
                     else
                       "Failed to create project due to an unknown error."
                     end
    
    flash.now[:alert] = error_message
    render :index
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :objectives, :status)
  end

  def create_timeline(project)
    timeline = project.build_timeline(
      start_date: params[:project][:start_date],
      end_date: params[:project][:end_date]
    )
    unless timeline.save
      project.errors.add(:timeline, timeline.errors.full_messages.join(", "))
      raise ActiveRecord::RecordInvalid.new(timeline)
    end
  end

  def create_student_assignments(project, user_ids)
    return if user_ids.blank?

    user_ids.reject(&:blank?).each do |user_id|
      user = User.find_by(id: user_id.to_i)
      if user
        assignment = project.student_assignments.build(user: user)
        unless assignment.save
          project.errors.add(:student_assignments, "Error assigning user #{user.id}: #{assignment.errors.full_messages.join(', ')}")
          raise ActiveRecord::RecordInvalid.new(assignment)
        end
      else
        project.errors.add(:student_assignments, "User not found for id: #{user_id}")
        raise ActiveRecord::RecordInvalid.new(project)
      end
    end
  end

end
