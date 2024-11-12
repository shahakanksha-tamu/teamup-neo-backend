# frozen_string_literal: true

# Class to edit student score
class ScoreController < ApplicationController
  before_action :index

  def index
    # @students = User.where(role: :student)
    @project = Project.find(params[:project_id])
    @students = @project.users
    @show_sidebar = !@project.nil?
  end

  def update
    params[:students].each do |id, score_params|
      student = User.find_by(id:)
      student&.update(score: score_params[:score])
    end

    redirect_to project_view_score_path, notice: 'Score updated successfully!'
  end

  # def edit
  #   @students = User.where(role: :student)
  # end
end
