# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectHubController, type: :controller do
  let(:user) { create(:user) }

  context 'when the user is logged in' do
    before do
      session[:user_id] = user.id
    end

    it 'sees project hub dashboard' do
      user.update(role: :student)
      get :index
      expect(response).to render_template(:index)
    end
  end
end
