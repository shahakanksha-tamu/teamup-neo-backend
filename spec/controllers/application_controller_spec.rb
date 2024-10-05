require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "Hello, world!"
    end
  end

  describe '#current_user' do
    context 'when user is logged in' do
      let(:user) { double('User', id: 1) } 

      before do
        allow(User).to receive(:find).with(1).and_return(user) # Mock find method
        session[:user_id] = 1
        get :index
      end

      it 'returns the current user' do
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      before do
        session[:user_id] = nil
        get :index
      end

      it 'returns nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe '#logged_in?' do
    context 'when user is logged in' do
      let(:user) { double('User', id: 1) } 

      before do
        allow(User).to receive(:find).with(1).and_return(user) 
        session[:user_id] = 1
        get :index
      end

      it 'returns true' do
        expect(controller.send(:logged_in?)).to be_truthy
      end
    end

    context 'when user is not logged in' do
      before do
        session[:user_id] = nil
        get :index
      end

      it 'returns false' do
        expect(controller.send(:logged_in?)).to be_falsey
      end
    end
  end

  describe '#require_login' do
    context 'when user is logged in' do
      let(:user) { double('User', id: 1) } 

      before do
        allow(User).to receive(:find).with(1).and_return(user) 
        session[:user_id] = 1
        get :index
      end

      it 'does not redirect' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not logged in' do
      before do
        session[:user_id] = nil
        get :index
      end

      it 'redirects to root_path with an alert' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You must be logged in to access the resource.")
      end
    end
  end
end