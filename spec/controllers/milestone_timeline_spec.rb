# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectHubController, type: :controller do
  describe 'project_hub#update_task_status' do
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

    it 'updates the task status' do
      patch :update_task_status, params: { project_id: project.id, student_id: logged_in_user.id, id: Task.find_by(task_name: 'milestone 1 task 1').id, status: 'In-Progress' }
      status = Task.find_by(task_name: 'milestone 1 task 1').status
      expect(status).to eq('In-Progress')
    end

    context 'when the update fails' do
      before do
        allow_any_instance_of(Task).to receive(:update).and_return(false) # rubocop:disable RSpec/AnyInstance
      end

      it 'returns the appropriate json' do
        patch :update_task_status, params: { project_id: project.id, student_id: logged_in_user.id, id: Task.find_by(task_name: 'milestone 1 task 1').id, status: 'Invalid task status' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'project_hub#timeline' do
    let(:logged_in_user) do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
    end
    let(:project) { create(:project) }

    before do
      session[:user_id] = logged_in_user.id
      StudentAssignment.create(user_id: logged_in_user.id, project_id: project.id)
      allow(controller).to receive(:current_user).and_return(logged_in_user)
    end

    context 'when the user has an assigned project' do
      before do
        # Creating milestones with different statuses
        create(:milestone, project:, title: 'Milestone 1', status: 'In-Progress')
        create(:milestone, project:, title: 'Milestone 2', status: 'Completed')
      end

      it 'assigns @milestones for the user’s project' do
        get :timeline, params: { project_id: project.id, student_id: logged_in_user.id }
        expect(assigns(:milestones)).to match_array(project.milestones)
        expect(assigns(:show_sidebar)).to be true
      end

      it 'filters milestones by status if status parameter is present' do
        get :timeline, params: { project_id: project.id, student_id: logged_in_user.id, status: 'In-Progress' }
        expect(assigns(:milestones)).to contain_exactly(project.milestones.find_by(status: 'In-Progress'))
      end
    end
  end

  describe 'project_hub#show_milestones' do
    let(:logged_in_user) do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
    end
    let(:project) { create(:project) }

    before do
      session[:user_id] = logged_in_user.id
      StudentAssignment.create(user_id: logged_in_user.id, project_id: project.id)
      allow(controller).to receive(:current_user).and_return(logged_in_user)
    end

    context 'when the user has an assigned project' do
      before do
        # Creating milestones with different statuses
        create(:milestone, project:, title: 'Milestone 1', status: 'In-Progress')
        create(:milestone, project:, title: 'Milestone 2', status: 'Completed')
      end

      it 'assigns @milestones for the user’s project' do
        get :show_milestones, params: { project_id: project.id, student_id: logged_in_user.id }
        expect(assigns(:milestones)).to match_array(project.milestones)
        expect(assigns(:show_sidebar)).to be true
        expect(assigns(:role)).to eq(logged_in_user.role)
      end

      it 'filters milestones by status if status parameter is present' do
        get :show_milestones, params: { project_id: project.id, student_id: logged_in_user.id, status: 'In-Progress' }
        expect(assigns(:milestones)).to contain_exactly(project.milestones.find_by(status: 'In-Progress'))
      end
    end
  end
end
