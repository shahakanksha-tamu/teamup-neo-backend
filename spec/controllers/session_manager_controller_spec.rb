# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManagerController, type: :controller do
  after do
    User.destroy_all
  end

  before do
    User.create(
      first_name: 'FN',
      last_name: 'LN',
      email: 'testuser@gmail.com',
      role: 'admin',
      provider: 'google_oauth2'
    )
  end

  describe 'GET #logout' do
    let(:user) do
      User.find_by(email: 'testuser@gmail.com')
    end

    before do
      session[:user_id] = user.id
    end

    it 'resets the session and redirects to root path with a notice' do # rubocop:disable RSpec/MultipleExpectations
      get :logout
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('You are logged out.')
    end

    it 'redirects to dashboard with an alert if an error occurs' do # rubocop:disable RSpec/MultipleExpectations
      allow(controller).to receive(:reset_session).and_raise(StandardError, 'An error occurred')
      get :logout
      expect(response).to redirect_to(dashboard_path)
      expect(flash[:alert]).to eq('Failed to logout: An error occurred')
    end
  end

  describe 'POST #google_oauth_callback_handler' do
    let(:user) do
      User.find_by(email: 'testuser@gmail.com')
    end

    context 'when user is found' do
      before do
        request.env['omniauth.auth'] = {
          'info' => { 'email' => user.email },
          'provider' => user.provider
        }
      end

      it 'logs in the user and redirects to the dashboard' do # rubocop:disable RSpec/MultipleExpectations
        post :google_oauth_callback_handler
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:notice]).to eq('You are logged in.')
      end
    end

    context 'when user is not found' do
      before do
        request.env['omniauth.auth'] = {
          'info' => { 'email' => 'nonexistent@gmail.com' },
          'provider' => 'google_oauth2'
        }
      end

      it 'fails to log in and redirects to the root path' do # rubocop:disable RSpec/MultipleExpectations
        post :google_oauth_callback_handler
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Login failed.')
      end
    end
  end

  describe 'GET #google_oauth_failure_handler' do
    context 'when authentication fails' do
      it 'redirects to root path with an alert message' do # rubocop:disable RSpec/MultipleExpectations
        get :google_oauth_failure_handler, params: { message: 'invalid_credentials' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed: Invalid credentials')
      end
    end

    context 'when other error messages are provided' do
      it 'humanizes the failure message and shows the alert' do # rubocop:disable RSpec/MultipleExpectations
        get :google_oauth_failure_handler, params: { message: 'account_disabled' }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed: Account disabled')
      end
    end
  end
end
