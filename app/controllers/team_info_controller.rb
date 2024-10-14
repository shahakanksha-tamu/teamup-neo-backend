# frozen_string_literal: true

# TeamInfoController displays team member information and key contacts
class TeamInfoController < ApplicationController
  def index
    @users = User.where(role: 'student')
    @mentors = fetch_all_mentors
  end

  private

  def fetch_all_mentors
    User.where(role: 'admin')
  end
end
