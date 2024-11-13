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
      role: 'student',
      provider: 'google_oauth2'
    )

    User.create(
      first_name: 'FN',
      last_name: 'LN',
      email: 'testuser2@gmail.com',
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

    it 'resets the session and redirects to root path with a notice' do
      get :logout
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('You are logged out.')
    end
  end

  describe 'POST #google_oauth_callback_handler' do
    let(:user) do
      User.find_by(email: 'testuser@gmail.com')
    end

    let(:admin_user) do
      User.find_by(email: 'testuser2@gmail.com')
    end

    context 'when user is student' do
      before do
        request.env['omniauth.auth'] = {
          'info' => { 'email' => user.email },
          'provider' => user.provider
        }
      end

      it 'logs in the student and redirects to the project_hub' do
        post :google_oauth_callback_handler
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(project_hub_path)
        expect(flash[:notice]).to eq('You are logged in.')
      end
    end

    context 'when user is admin' do
      before do
        request.env['omniauth.auth'] = {
          'info' => { 'email' => admin_user.email },
          'provider' => user.provider
        }
      end

      it 'logs in the admin and redirects to the project management hub' do
        post :google_oauth_callback_handler
        expect(session[:user_id]).to eq(admin_user.id)
        expect(response).to redirect_to(project_management_hub_path)
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

      it 'fails to log in and redirects to the root path' do
        post :google_oauth_callback_handler
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Login failed.')
      end
    end
  end

  describe 'GET #google_oauth_failure_handler' do
    context 'when authentication fails' do
      it 'redirects to root path with an alert message' do
        get :google_oauth_failure_handler, params: { message: 'invalid_credentials' }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed: Invalid credentials')
      end
    end

    context 'when other error messages are provided' do
      it 'humanizes the failure message and shows the alert' do
        get :google_oauth_failure_handler, params: { message: 'account_disabled' }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed: Account disabled')
      end
    end
  end
end
