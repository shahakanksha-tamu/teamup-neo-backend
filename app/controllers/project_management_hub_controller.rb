class ProjectManagementHubController < ApplicationController
    before_action :set_user_role

    def set_user_role
        @role = User.find(session[:user_id]).role
        unless @role
            redirect_to landing_page_path
        end
        if @role == 'student'
            redirect_to dashboard_path
        end
    end

    def index
        @user = User.find(session[:user_id])
    end
end
