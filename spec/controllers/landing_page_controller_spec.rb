# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LandingPageController, type: :controller do
  describe 'GET #index' do
    context 'when the user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
        get :index
      end

      it 'redirects to the dashboard' do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when the user is not logged in' do
      before { get :index }

      it 'renders the landing page' do
        expect(response).to render_template(:index)
      end
    end
  end
end
