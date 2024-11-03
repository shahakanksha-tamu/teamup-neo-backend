# frozen_string_literal: true

# Class to edit student score
class ScoreController < ApplicationController
  before_action :edit

  def edit
    @students = User.where(role: :student)
  end

  def update
    @students.each do |s|
      s.update(score: params[:students][s.id.to_s][:score])
    end

    redirect_to edit_score_path, notice: 'Scores updated successfully.'
  end
end
