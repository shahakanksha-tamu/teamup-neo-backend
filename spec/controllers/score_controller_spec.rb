# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoreController, type: :controller do
  let!(:admin_user) { create(:user, role: :admin) }
  let!(:student1) { create(:user, role: :student, score: 0) }
  let!(:student2) { create(:user, role: :student, score: 0) }

  before do
    session[:user_id] = admin_user.id
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'when updating scores' do
      it 'updates the scores for the students' do
        patch :update, params: { students: { student1.id.to_s => { score: 95 }, student2.id.to_s => { score: 88 } } }

        student1.reload
        student2.reload

        expect(student1.score).to eq(95)
        expect(student2.score).to eq(88)
        expect(flash[:notice]).to eq('Scores updated successfully.')
      end
    end
  end
end
