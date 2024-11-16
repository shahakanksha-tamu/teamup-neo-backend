# frozen_string_literal: true

# spec/controllers/task_management_controller_spec.rb

require 'rails_helper'

RSpec.describe TaskManagementController, type: :controller do
  let(:user) { create(:user) }

  let!(:project) { Project.create(name: 'Test Project',start_date: Date.today, end_date: Date.today + 1.year) }
  let!(:milestone) { Milestone.create(title: 'Test Milestone', project:, start_date: Date.today + 1.week , deadline: Date.today + 11.month, deadline: 5.days.from_now) }
  let!(:student) { User.create(first_name: 'John', last_name: 'Doe', role: 'student', email: 'john.doe@example.com') }
  let!(:task) { Task.create(task_name: 'Sample Task', milestone_id: milestone.id, description: 'Sample description', status: 'Completed') }
  let!(:task1) { Task.create(task_name: 'Sample Task 1 ', milestone_id: milestone.id, description: 'Sample description 1', status: 'Not Completed') }

  before do
    session[:user_id] = user.id
    TaskAssignment.create(user: student, task:)
    TaskAssignment.create(user: student, task: task1)
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
      expect(assigns(:show_sidebar)).to be(true)
    end

    it 'calculates the correct completion percentage for John' do
      # Triggering the controller action
      get :index, params: { project_id: project.id }

      # John should have 50% completion since one task is completed and one is not
      expect(assigns(:completion_percentages)[student.id]).to eq(50.0)
    end
  end

  describe 'POST #create' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:task_params) do
      {
        task: {
          task_name: 'New Task',
          status: 'Not Started',
          milestone_id: milestone.id,
          deadline: '2024-05-05 12:00:00',
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

    context 'when task deadline exceeds milestone deadline' do
      it 'sets a flash alert and redirects to the task management page' do
        task_params[:task][:deadline] = (milestone.deadline + 1.day).strftime('%Y-%m-%d %H:%M:%S')

        post :create, params: task_params

        expect(flash[:alert]).to eq("Deadline cannot be greater than the milestone's deadline.")
        expect(response).to redirect_to(project_task_management_path(project))
      end
    end

    context 'when task name is duplicated' do
      it 'sets a flash alert and redirects to the task management page' do
        Task.create!(task_name: 'Duplicate Task', milestone_id: milestone.id, description: 'Duplicate description')
        task_params[:task][:task_name] = 'Duplicate Task'

        post :create, params: task_params

        expect(flash[:error]).to eq('Task name must be unique within the same milestone')
        expect(response).to redirect_to(project_task_management_path(project))
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

    context 'when task deadline exceeds milestone deadline' do
      it 'sets a flash alert and redirects to the task management page' do
        patch :update, params: {
          project_id: project.id,
          user_id: user.id,
          id: task.id,
          task: { deadline: (milestone.deadline + 1.day).strftime('%Y-%m-%d %H:%M:%S') }
        }
        expect(flash[:alert]).to eq("Deadline cannot be greater than the milestone's deadline.")
        expect(response).to redirect_to(project_task_management_path(project))
      end
    end
  end
end
