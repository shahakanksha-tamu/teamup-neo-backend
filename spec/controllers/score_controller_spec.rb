# frozen_string_literal: true

require 'rails_helper'

# RSpec.describe ScoreController, type: :controller do
#   let!(:admin_user) { create(:user, role: :admin) }
#   let!(:student1) { create(:user, role: :student, score: 0) }
#   let!(:student2) { create(:user, role: :student, score: 0) }

#   before do
#     session[:user_id] = admin_user.id
#   end

#   describe 'GET #index' do
#     it 'renders the edit template' do
#       get :index
#       expect(response).to render_template(:index)
#     end
#   end

#   describe 'PATCH #update' do
#     context 'when updating scores' do
#       it 'updates the scores for the students' do
#         patch :update, params: { students: { student1.id.to_s => { score: 95 }, student2.id.to_s => { score: 88 } } }

#         student1.reload
#         student2.reload

#         expect(student1.score).to eq(95)
#         expect(student2.score).to eq(88)
#         expect(flash[:notice]).to eq('Score updated successfully!')
#       end
#     end
#   end
# end

RSpec.describe ScoreController, type: :controller do
  let!(:admin_user) { create(:user, role: :admin) }
  let!(:project) { create(:project) }
  let!(:student1) { create(:user, role: :student, score: 0) }
  let!(:student2) { create(:user, role: :student, score: 0) }

  before do
    project.users << student1
    project.users << student2
    session[:user_id] = admin_user.id
  end

  describe 'GET #index' do
    it 'renders the index template and assigns project and students' do
      get :index, params: { project_id: project.id }
      expect(response).to render_template(:index)
      expect(assigns(:project)).to eq(project)
      expect(assigns(:students)).to include(student1, student2)
      expect(assigns(:show_sidebar)).to be true
    end
  end

  describe 'PATCH #update' do
    context 'when updating scores' do
      it 'updates the scores for the students' do
        patch :update, params: { project_id: project.id, students: { student1.id.to_s => { score: 95 }, student2.id.to_s => { score: 88 } } }

        student1.reload
        student2.reload

        expect(student1.score).to eq(95)
        expect(student2.score).to eq(88)
        expect(response).to redirect_to(project_view_score_path)
        expect(flash[:notice]).to eq('Score updated successfully!')
      end
    end
  end
end
