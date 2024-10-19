# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagementHubController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'assigns the requested project to @project' do
      get :team, params: { project_id: project.id }
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #add_student' do
    let(:student) { create(:user) }

    context 'when successfully adding a student' do
      before do
        allow_any_instance_of(Project).to receive(:add_student).and_return(true) # rubocop:disable RSpec/AnyInstance
      end

      it 'adds the student to the project' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(flash[:success]).to include("#{student.email} was successfully added to the team")
      end

      it 'redirects to the team page' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(response).to redirect_to(project_team_management_path(project)) # Corrected path helper
      end
    end

    context 'when failing to add a student' do
      before do
        allow_any_instance_of(Project).to receive(:add_student).and_return(false) # rubocop:disable RSpec/AnyInstance
      end

      it 'sets an error flash message' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(flash[:error]).to include('Failed to add student to the team')
      end

      it 'redirects to the team page' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(response).to redirect_to(project_team_management_path(project)) # Corrected path helper
      end
    end
  end

  describe 'DELETE #remove_student' do
    let(:student) { create(:user) }

    context 'when successfully removing a student' do
      before do
        allow_any_instance_of(Project).to receive(:remove_student).and_return(true) # rubocop:disable RSpec/AnyInstance
      end

      it 'removes the student from the project' do
        delete :remove_student, params: { project_id: project.id, user_id: student.id }
        expect(flash[:success]).to include("#{student.email} was successfully removed from the team")
      end

      it 'redirects to the team page' do
        delete :remove_student, params: { project_id: project.id, user_id: student.id }
        expect(response).to redirect_to(project_team_management_path(project)) # Corrected path helper
      end
    end

    context 'when failing to remove a student' do
      before do
        allow_any_instance_of(Project).to receive(:remove_student).and_return(false) # rubocop:disable RSpec/AnyInstance
      end

      it 'sets an error flash message' do
        delete :remove_student, params: { project_id: project.id, user_id: student.id }
        expect(flash[:error]).to include("Failed to remove #{student.email} from the team")
      end

      it 'redirects to the team page' do
        delete :remove_student, params: { project_id: project.id, user_id: student.id }
        expect(response).to redirect_to(project_team_management_path(project)) # Corrected path helper
      end
    end
  end
end
