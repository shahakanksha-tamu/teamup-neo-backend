# frozen_string_literal: true

# TeamInfoController displays team member information and key contacts
class TeamInfoController < ApplicationController
  def index
    @users = User.limit(8)
  end
end
