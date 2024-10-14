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
end
