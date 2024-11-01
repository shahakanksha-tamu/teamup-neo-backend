# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectHubController, type: :controller do
  let(:user) do
    User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
  end
  context 'when the user is logged in and has no project assignment' do
    before do
      session[:user_id] = user.id
    end
    it 'sees project hub dashboard' do
      get :index
      expect(response).to redirect_to(dashboard_path)
    end
  end
  context 'when the user is logged in and has a project assignment' do
    let(:project) { create(:project) }

    before do
      session[:user_id] = user.id
      StudentAssignment.create(user_id: user.id, project_id: project.id)
    end

    it 'sees project hub dashboard' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end