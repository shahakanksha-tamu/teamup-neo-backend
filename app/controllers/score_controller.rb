# frozen_string_literal: true

# Class to edit student score
class ScoreController < ApplicationController
  before_action :index

  def index
    @students = User.where(role: :student)
    # @project = Project.find(params[:project_id])
    # @students = @project.users
  end

  def update
    params[:students].each do |id, score_params|
      student = User.find_by(id:)
      if score_params[:score].to_f > 100
        redirect_to view_score_path, alert: 'Failed to update score. Max allowed score is 100'
        return nil
      end
      student&.update(score: score_params[:score])
    end

    redirect_to view_score_path, notice: 'Score updated successfully!'
  end

  # def edit
  #   @students = User.where(role: :student)
  # end
end
