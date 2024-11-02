# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  # let(:user) { create(:user) }
  # let(:project) { create(:project) }

  before do
    @user = User.create!(first_name: "First", last_name: "Last", email: "user@example.com",role: 'student')
    session[:user_id] = @user.id
  end

  describe 'GET #index' do
    context 'when the user has project assignments' do
      before do
        @project = Project.create!(name: "Project 1", description: "Project description", status: "active")
        StudentAssignment.create!(user: @user, project: @project)
        get :index
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq([@project])
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when the user has no project assignments' do
      before do
        get :index
      end

      it 'assigns @projects as an empty array' do
        expect(assigns(:projects)).to eq([])
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end
end