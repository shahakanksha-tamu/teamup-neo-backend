# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  let(:user) { create(:user) }

  before do
    session[:user_id] = user.id if user_logged_in
  end

  describe 'GET #index' do
    let(:user_logged_in) { true }

    context 'when the user is logged in' do
      it 'renders the settings index for student role' do
        user.update(role: 'student')
        get :index
        expect(response).to render_template(:index)
      end

      it 'renders the settings index for admin role' do
        user.update(role: 'admin')
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when the user is not logged in' do
      let(:user_logged_in) { false }

      it 'redirects to the landing page' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
