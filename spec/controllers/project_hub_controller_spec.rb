# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectHubController, type: :controller do
  describe 'project_hub#index' do
    let(:logged_in_user) do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
    end

    let(:other_user) do
      User.create!(first_name: 'Test Name', last_name: 'Test Last Name', contact: '178683473', role: 'student', email: 'testuser@gmail.com')
    end

    context 'when the user is logged in and has no project assignment' do
      before do
        session[:user_id] = logged_in_user.id
      end

      it 'sees project hub dashboard' do
        get :index
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when the user is logged in and has a project assignment' do
      let(:project) { create(:project) }

      before do
        session[:user_id] = logged_in_user.id
        StudentAssignment.create(user_id: logged_in_user.id, project_id: project.id)
      end

      it 'sees project hub dashboard' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'project_hub#view_tasks' do
    let(:project) { create(:project) }

    let(:logged_in_user) do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
    end

    let(:other_user) do
      User.create!(first_name: 'Test Name', last_name: 'Test Last Name', contact: '178683473', role: 'student', email: 'testuser@gmail.com')
    end

    before do
      session[:user_id] = logged_in_user.id
      StudentAssignment.create(user_id: logged_in_user.id, project_id: project.id)
      StudentAssignment.create(user_id: other_user.id, project_id: project.id)

      Milestone.create(project_id: project.id, title: 'milestone 1 title', objective: 'milestone 1 objective', status: 'In-Progress', deadline: '2024-12-12')
      Milestone.create(project_id: project.id, title: 'milestone 2 title', objective: 'milestone 1 objective', status: 'Not Started', deadline: '2024-12-12')

      Task.create(task_name: 'milestone 1 task 1', status: 'Not Started', deadline: '2024-12-10', milestone_id: Milestone.find_by(title: 'milestone 1 title').id, description: 'milestone 1 task 1 description')
      Task.create(task_name: 'milestone 1 task 2', status: 'In-Progress', deadline: '2024-12-10', milestone_id: Milestone.find_by(title: 'milestone 1 title').id, description: 'milestone 1 task 2 description')
      Task.create(task_name: 'milestone 1 task 3', status: 'Not Started', deadline: '2024-12-10', milestone_id: Milestone.find_by(title: 'milestone 1 title').id, description: 'milestone 1 task 3 description')

      TaskAssignment.create(user_id: logged_in_user.id, task_id: Task.find_by(task_name: 'milestone 1 task 1').id)
      TaskAssignment.create(user_id: logged_in_user.id, task_id: Task.find_by(task_name: 'milestone 1 task 2').id)
      TaskAssignment.create(user_id: other_user.id, task_id: Task.find_by(task_name: 'milestone 1 task 3').id)

      allow(controller).to receive(:current_user).and_return(logged_in_user)
    end

    context 'when user has tasks assigned' do
      let(:expected_result) do
        Task.joins(:task_assignment, :milestone)
            .where(task_assignments: { user_id: logged_in_user.id })
            .select('tasks.*, milestones.title, milestones.deadline, milestones.status as milestone_status')
            .group_by(&:status)
      end

      it 'shows the sidebar' do
        get :view_tasks, params: { project_id: project.id, student_id: logged_in_user.id }
        expect(assigns(:show_sidebar)).to be true
      end

      it 'loads the logged in user tasks' do
        get :view_tasks, params: { project_id: project.id, student_id: logged_in_user.id }
        expected_result = Task.joins(:task_assignment, :milestone)
                              .where(task_assignments: { user_id: logged_in_user.id })
                              .select('tasks.*, milestones.title, milestones.deadline, milestones.status as milestone_status')
                              .group_by(&:status)

        not_started_array = expected_result['Not Started'].sort_by(&:milestone_id)
        in_progress_array = expected_result['In-Progress'].sort_by(&:milestone_id)
        expect(assigns(:current_user_tasks)).to eq(expected_result)
        expect(assigns(:not_started_tasks)).to eq(not_started_array)
        expect(assigns(:in_progress_tasks)).to eq(in_progress_array)
        expect(assigns(:not_completed_tasks)).to eq([])
        expect(assigns(:completed_tasks)).to eq([])
        expect(assigns(:total_count)).to eq(2)
      end
    end
  end

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
end