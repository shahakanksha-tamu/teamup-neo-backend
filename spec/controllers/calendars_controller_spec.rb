require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do
  let(:user) { create(:user) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
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
