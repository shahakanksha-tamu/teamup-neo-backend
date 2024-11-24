# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoreController, type: :controller do
  let!(:admin_user) { create(:user, role: :admin) }
  let!(:project) { create(:project) }
  let!(:first_student) { create(:user, role: :student) }
  let!(:second_student) { create(:user, role: :student) }

  before do
    project.users << first_student
    project.users << second_student
    session[:user_id] = admin_user.id
  end

  describe 'GET #index' do
    it 'renders the index template and assigns project and students' do
      get :index, params: { project_id: project.id }
      expect(response).to render_template(:index)
      expect(assigns(:students)).to include(first_student, second_student)
    end
  end

  describe 'PATCH #update' do
    context 'when updating scores' do
      it 'updates the scores for the students' do
        patch :update, params: { project_id: project.id, students: { first_student.id.to_s => { score: 95, max_score: 100 }, second_student.id.to_s => { score: 88, max_score: 120 } } }

        first_student.reload
        second_student.reload

        expect(first_student.score).to eq(95)
        expect(second_student.score).to eq(88)
        expect(response).to redirect_to(view_score_path)
        expect(flash[:notice]).to eq('Score updated successfully!')
      end
    end
  end
end
