# frozen_string_literal: true

# Class to edit student score
class ScoreController < ApplicationController
  before_action :index

  def index
    # @project = Project.find(params[:project_id])
    # @students = @project.users
    @students = User.where(role: :student)
  end

  def update
    params[:students].each do |id, score_params|
      student = User.find_by(id:)
      if score_params[:score].to_f > score_params[:max_score].to_f
        redirect_to view_score_path, alert: "Failed to update score. Max allowed score is #{score_params[:max_score]}"
        return nil
      end
      student&.update(score: score_params[:score])
      student&.update(max_score: score_params[:max_score])
    end

    redirect_to view_score_path, notice: 'Score updated successfully!'
  end
end
