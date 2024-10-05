require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        session[:user_id] = user.id
      end

      it 'assigns the current user to @user' do
        get :index
        expect(assigns(:user)).to eq(user)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
