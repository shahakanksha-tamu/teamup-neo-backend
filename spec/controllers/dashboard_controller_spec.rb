# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'Resource Authorization' do
    context 'when user is not logged in' do
      before do
        session[:user_id] = nil
      end

      it 'redirects the user to landing page when the user attempts to access the protected resources' do
        get :index
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be logged in to access the resource.')
      end
    end
  end
end
