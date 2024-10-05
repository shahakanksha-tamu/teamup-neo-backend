# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagementHubController, type: :controller do
  let(:user) { create(:user) }

  context 'when the user is logged in' do
    before do
      session[:user_id] = user.id
    end

    it 'redirects to the dashboard if the user role is student' do
      user.update(role: :student)
      get :index
      expect(response).to redirect_to(dashboard_path)
    end

    it 'renders the project hub index if the user role is admin' do
      user.update(role: :admin)
      get :index
      expect(response).to render_template(:index)
    end
  end
end
