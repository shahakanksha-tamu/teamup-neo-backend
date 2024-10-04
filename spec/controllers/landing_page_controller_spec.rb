# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LandingPageController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  context 'when the user is logged in' do
    before do
      allow(controller).to receive(:logged_in?).and_return(true)
    end

    it 'redirects to the dashboard page' do
      get :index
      expect(response).to redirect_to(dashboard_path)
    end
  end
end
