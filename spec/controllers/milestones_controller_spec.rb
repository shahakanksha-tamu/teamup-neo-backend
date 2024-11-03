# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MilestonesController, type: :controller do
  let(:project) { create(:project) }

  let(:logged_in_user) do
    User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
  end

  before do
    session[:user_id] = logged_in_user.id
    StudentAssignment.create(user_id: logged_in_user.id, project_id: project.id)
    Milestone.create(project_id: project.id, title: 'milestone 1 title', objective: 'milestone 1 objective', status: 'In-Progress', deadline: '2024-12-12')
    Task.create(task_name: 'milestone 1 task 1', status: 'Not Started', deadline: '2024-12-10', milestone_id: Milestone.find_by(title: 'milestone 1 title').id, description: 'milestone 1 task 1 description')
    TaskAssignment.create(user_id: logged_in_user.id, task_id: Task.find_by(task_name: 'milestone 1 task 1').id)
    allow(controller).to receive(:current_user).and_return(logged_in_user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { project_id: project.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'redirects to the milestones index page' do
      post :create, params: { project_id: project.id, milestone: { title: 'Milestone 2', objective: 'Milestone 2 objective', deadline: 1.week.from_now } }
      expect(response).to redirect_to(project_milestones_path(project))
    end

    it 'redirects to the milestones index page when deadline is less than 1 week from now' do
      post :create, params: { project_id: project.id, milestone: { title: 'Milestone 2', objective: 'Milestone 2 objective', deadline: 1.day.from_now } }
      expect(response).to redirect_to(project_milestones_path(project))
    end

    context 'when the deadline is at least one week in the future' do
      it 'creates a new milestone and redirects to the milestones index page' do
        expect do
          post :create, params: { project_id: project.id, milestone: { title: 'Milestone 3', objective: 'Milestone 3 objective', deadline: 1.week.from_now + 1.day } }
        end.to change(Milestone, :count).by(1)

        expect(response).to redirect_to(project_milestones_path(project))
        expect(flash[:notice]).to eq('Milestone was successfully created.')
      end
    end

    context 'when the milestone fails to save' do
      it 'renders the index template with errors' do
        allow_any_instance_of(Milestone).to receive(:save).and_return(false)

        post :create, params: { project_id: project.id, milestone: { title: '', objective: '', deadline: 1.week.from_now + 1.day } }

        expect(response).to render_template(:index)
        expect(assigns(:milestones)).to eq(project.milestones)
      end
    end
  end

  describe 'PATCH #update' do
    it 'redirects to the milestones index page' do
      patch :update, params: { project_id: project.id, id: Milestone.find_by(title: 'milestone 1 title').id, milestone: { title: 'Milestone 1 updated', objective: 'Milestone 1 objective updated', deadline: 1.week.from_now } }
      expect(response).to redirect_to(project_milestones_path(project))
    end

    it 'sets flash error message when update fails' do
      milestone = Milestone.find_by(title: 'milestone 1 title')

      allow_any_instance_of(Milestone).to receive(:update).and_return(false)

      patch :update_milestone_status, params: { project_id: project.id, id: milestone.id, milestone: { status: 'Completed' } }

      expect(flash[:error]).to eq('Failed to update status')
      expect(response).to redirect_to(project_milestones_path(project))
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      milestone = Milestone.find_by(title: 'milestone 1 title')
      get :edit, params: { project_id: project.id, id: milestone.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update_milestone_status' do
    it 'redirects to the milestones index page' do
      patch :update_milestone_status, params: { project_id: project.id, id: Milestone.find_by(title: 'milestone 1 title').id, milestone: { status: 'Completed' } }
      expect(response).to redirect_to(project_milestones_path(project))
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to the milestones index page' do
      delete :destroy, params: { project_id: project.id, id: Milestone.find_by(title: 'milestone 1 title').id }
      expect(response).to redirect_to(project_milestones_path(project))
    end
  end

  describe 'GET #edit for milestone' do
    it 'assigns the requested milestone to @milestone' do
      milestone = Milestone.find_by(title: 'milestone 1 title')
      get :edit, params: { project_id: project.id, id: milestone.id }
      expect(assigns(:milestone)).to eq(milestone)
    end
  end
end
