# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) do
    User.create!(first_name: 'First', last_name: 'Last', email: 'user@example.com', role: 'student')
  end

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    context 'when the user has project assignments' do
      let(:project) do
        Project.create!(name: 'Project 1', description: 'Project description', status: 'active')
      end

      before do
        StudentAssignment.create!(user:, project:)
        get :index
      end

      it 'assigns @projects' do
        expect(assigns(:projects)).to eq([project])
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
