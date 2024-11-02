# frozen_string_literal: true

# spec/controllers/task_management_controller_spec.rb

require 'rails_helper'

RSpec.describe TaskManagementController, type: :controller do
  let(:user) { create(:user) }

  let!(:project) { Project.create(name: 'Test Project') }
  let!(:milestone) { Milestone.create(title: 'Test Milestone', project:) }
  let!(:student) { User.create(first_name: 'John', last_name: 'Doe', role: 'student', email: 'john.doe@example.com') }
  let!(:task) { Task.create(task_name: 'Sample Task', milestone_id: milestone.id, description: 'Sample description') }

  before do
    session[:user_id] = user.id
    TaskAssignment.create(user: student, task:)
    project.users << student
    user.tasks << task
  end

  describe 'GET #index' do
    before do
      get :index, params: { project_id: project.id }
      puts "Assigned project: #{assigns(:project).inspect}" # Debug @project
      puts "Assigned students: #{assigns(:students).inspect}" # Debug @students
    end

    it 'responds successfully' do
      expect(response).to have_http_status(:success) # or :ok
    end

    it 'assigns the project to @project' do
      expect(assigns(:project)).to eq(project)
    end

    it 'assigns the project users with task assignments to @students' do
      expect(assigns(:students)).not_to be_nil # Check @students is not nil
      expect(assigns(:students).to_a).to match_array(project.users.to_a)
    end

    it 'sets @show_sidebar to true when project is present' do
      expect(assigns(:show_sidebar)).to eq(true)
    end
  end

  describe 'POST #create' do
    let(:task_params) do
      {
        task: {
          task_name: 'New Task',
          status: 'Not Started',
          milestone_id: milestone.id,
          deadline: '2024-12-01 12:00:00',
          description: 'A sample description'
        },
        user_id: student.id,
        project_id: project.id
      }
    end

    context 'with valid parameters' do
      it 'creates a new task and assigns it to the student' do
        expect do
          post :create, params: task_params
        end.to change(Task, :count).by(1)
        expect(TaskAssignment.last.user_id).to eq(student.id)
        expect(response).to redirect_to(project_task_management_path(project))
      end
    end

    context 'with invalid parameters' do
      it 'renders the index template and logs errors' do
        invalid_params = task_params.deep_merge(task: { task_name: '' })
        post :create, params: invalid_params
        expect(response).to render_template(:index)
        expect(assigns(:task).errors[:task_name]).to include("can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    let(:update_params) do
      {
        id: task.id,
        task: { task_name: 'Updated Task' },
        project_id: project.id
      }
    end

    context 'with valid parameters' do
      it 'updates the task and redirects to the task management page' do
        patch :update, params: { project_id: project.id, user_id: user.id, id: task.id, task: { task_name: 'Updated Task' } }
        task.reload
        expect(task.task_name).to eq('Updated Task')
      end
    end

    context 'with invalid parameters' do
      it 'renders the index template and logs errors' do
        invalid_update_params = { project_id: project.id, user_id: user.id, id: task.id, task: { task_name: '' } }

        patch :update, params: invalid_update_params

        expect(response).to render_template(:index) # Expect to render index on failure
        expect(assigns(:task).errors[:task_name]).to include("can't be blank")
      end
    end
  end
end