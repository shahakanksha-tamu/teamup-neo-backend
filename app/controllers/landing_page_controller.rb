# frozen_string_literal: true

# LandingPageController handles all operations that user can perform when not logged in
class LandingPageController < ApplicationController
  skip_before_action :require_login, only: [:index]
  def index
    return unless logged_in?

    redirect_to dashboard_path
  end
end
