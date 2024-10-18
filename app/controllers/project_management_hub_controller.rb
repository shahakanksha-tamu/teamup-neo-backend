# frozen_string_literal: true

# Handles all functions related to the Project management hub page
class ProjectManagementHubController < ApplicationController
  def index
    @projects = Project.includes(:users, :timeline, milestones: :tasks)
  end

  def create_project # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @project = Project.new(project_params)

    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless @project.save

      begin
        create_timeline(@project)
        create_student_assignments(@project, params[:project][:user_ids])
      rescue ActiveRecord::RecordInvalid => e
        @project.errors.add(:base, "Error in associated data: #{e.message}")
        raise ActiveRecord::Rollback
      rescue StandardError => e
        @project.errors.add(:base, "Unexpected error: #{e.message}")
        raise ActiveRecord::Rollback
      end

      if @project.errors.empty? # rubocop:disable Style/GuardClause
        redirect_to project_management_hub_path, notice: 'Project was successfully created.' and return
      else
        raise ActiveRecord::Rollback
      end

      # Project failed to save due to validation errors
    end

    # If we've reached this point, the transaction has been rolled back
    error_message = if @project.errors.any?
                      @project.errors.full_messages.join(', ')
                    else
                      'Failed to create project due to an unknown error.'
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
    return if timeline.save

    project.errors.add(:timeline, timeline.errors.full_messages.join(', '))
    raise ActiveRecord::RecordInvalid, timeline
  end

  def create_student_assignments(project, user_ids) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    return if user_ids.blank?

    user_ids.reject(&:blank?).each do |user_id|
      user = User.find_by(id: user_id.to_i)
      if user
        assignment = project.student_assignments.build(user:)
        unless assignment.save
          project.errors.add(:student_assignments, "Error assigning user #{user.id}: #{assignment.errors.full_messages.join(', ')}")
          raise ActiveRecord::RecordInvalid, assignment
        end
      else
        project.errors.add(:student_assignments, "User not found for id: #{user_id}")
        raise ActiveRecord::RecordInvalid, project
      end
    end
  end
end
