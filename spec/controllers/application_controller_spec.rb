# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'Hello, world!'
    end
  end

  describe '#current_user' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'returns the current user' do
        get :index
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      it 'returns nil' do
        get :index
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'returns true' do
        get :index
        expect(controller.send(:logged_in?)).to be_truthy
      end
    end

    context 'when user is not logged in' do
      it 'returns false' do
        get :index
        expect(controller.send(:logged_in?)).to be_falsey
      end
    end
  end

  describe '#require_login' do
    context 'when user is not logged in' do
      before do
        session[:user_id] = nil
      end

      it 'redirects to root_path with an alert' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be logged in to access the resource.')
      end
    end
  end

  describe '#restrict_access_based_on_role' do
    let(:student_user) do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
    end

    let(:admin_user) do
      User.create!(first_name: 'FN', last_name: 'LN', contact: '2143454324', role: 'admin', email: 'test@gmail.com')
    end

    context 'when user is admin' do
      before do
        session[:user_id] = admin_user.id
      end

      it 'redirects to admin dashboard when admin accesses protected student resources' do
        allow(controller).to receive(:params).and_return({ controller: 'dashboard', action: 'index' })
        get :index
        expect(response).to redirect_to(project_management_hub_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end

      it 'allows access to admin-specific resources' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is student' do
      before do
        session[:user_id] = student_user.id
      end

      it 'redirects to student dashboard when student accesses protected admin resources' do
        allow(controller).to receive(:params).and_return({ controller: 'project_management_hub', action: 'index' })
        get :index
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end

      it 'allows access to student-specific resources' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
