# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagementHubController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:valid_attributes) do
    {
      name: 'Test Project',
      description: 'A test project',
      objectives: 'To test project creation',
      status: 'active',
      start_date: Time.zone.today,
      end_date: Time.zone.today + 30.days,
      user_ids: [user.id]
    }
  end

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
  it 'assigns all projects to @projects' do
    get :index
    expect(assigns(:projects)).to include(project)
  end

    it 'assigns the requested project to @project' do
      get :team, params: { project_id: project.id }
      expect(assigns(:project)).to eq(project)
    end

    context 'when an associated record fails to save' do
      before do
        allow_any_instance_of(Project).to receive(:save).and_return(true) # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Timeline).to receive(:save).and_return(false) # rubocop:disable RSpec/AnyInstance
      end

      it 'does not create a new project' do
        expect do
          post :create_project, params: { project: valid_attributes }
        end.not_to change(Project, :count)
      end

      it 'renders the index template with an alert' do
        post :create_project, params: { project: valid_attributes }
        expect(flash.now[:alert]).to be_present
      end
    end

    context 'when creating student assignments fails' do
      before do
        allow_any_instance_of(Project).to receive(:save).and_return(true) # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Timeline).to receive(:save).and_return(true) # rubocop:disable RSpec/AnyInstance
      end

      context 'when a user is not found' do # rubocop:disable RSpec/NestedGroups
        it 'raises an error and does not create a new project' do
          expect do
            post :create_project, params: { project: valid_attributes.merge(user_ids: [999]) } # Assuming 999 is an invalid user ID
          end.not_to change(Project, :count)
        end

        it 'renders the index template with an alert' do
          post :create_project, params: { project: valid_attributes.merge(user_ids: [999]) }
          expect(response).to redirect_to(project_management_hub_path)
        end
      end

      context 'when assignment fails to save' do # rubocop:disable RSpec/NestedGroups
        before do
          allow(controller).to receive(:create_student_assignments).and_raise(ActiveRecord::RecordInvalid.new(Project.new))
        end

        it 'does not create a new project' do
          expect do
            post :create_project, params: { project: valid_attributes.merge(user_ids: [1]) } # Assuming 1 is a valid user ID
          end.not_to change(Project, :count)
        end

        it 'renders the index template with an alert' do
          post :create_project, params: { project: valid_attributes.merge(user_ids: [1]) }
          expect(response).to redirect_to(project_management_hub_path)
        end
      end
    end
  end

  describe 'GET #dashboard' do
    context 'when project exists' do
      before do
        allow(Project).to receive(:find).with(project.id.to_s).and_return(project)
        allow(project).to receive(:progress).and_return(50) # Assuming progress is a percentage
        get :dashboard, params: { project_id: project.id }
      end

      it 'assigns the requested project to @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'sets @show_sidebar to true' do
        expect(assigns(:show_sidebar)).to be true
      end

      it 'calculates and assigns project progress' do
        expect(assigns(:progress)).to eq(50)
      end
    end

    context 'when project does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :dashboard, params: { project_id: -1 } # Invalid project ID
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #add_student' do
    let(:student) { create(:user) }
    let(:project) { create(:project) }

    context 'when the student is already assigned to a project' do
      let(:other_project) { create(:project) }
  
      before do
        # Create a StudentAssignment for the student and another project
        post :add_student, params: { project_id: other_project.id, user_id: student.id }
      end
  
      it 'sets an error flash message' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(flash[:error]).to include("#{student.email} is already assigned to a project.")
      end
  
      it 'redirects to the team management page' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(response).to redirect_to(project_team_management_path(project))
      end
    end
  
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
        expect(response).to redirect_to(project_team_management_path(project))
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
        expect(response).to redirect_to(project_team_management_path(project))
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
        expect(response).to redirect_to(project_team_management_path(project))
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
        expect(response).to redirect_to(project_team_management_path(project))
      end
    end
  end

  describe 'POST #create_project' do
    context 'with valid parameters' do
      it 'creates a new project' do
        expect do
          post :create_project, params: valid_attributes
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the project management hub with a notice' do
        post :create_project, params: valid_attributes
        expect(response).to redirect_to(project_management_hub_path)
      end

      it 'creates a timeline for the project' do
        expect do
          post :create_project, params: valid_attributes
        end.to change(Timeline, :count).by(1)
      end

      it 'creates student assignments' do
        expect do
          post :create_project, params: valid_attributes
        end.to change(StudentAssignment, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { valid_attributes.merge(end_date: Time.zone.today - 30.days) }

      it 'does not create a new project' do
        expect do
          post :create_project, params: invalid_attributes
        end.not_to change(Project, :count)
      end

      it 'renders the project management hub template with an alert' do
        post :create_project, params: invalid_attributes
        expect(flash.now[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    let(:project) { create(:project, name: 'Original Name', description: 'Original description') }
    
    let(:valid_update_attributes) do
      {
        project_id: project.id,
        project: {
          name: 'Updated Project Name',
          description: 'Updated description',
          objectives: 'Updated objectives',
          status: 'completed'
        }
      }
    end

    let(:invalid_update_attributes) do
      {
        project_id: project.id,
        project: {
          name: '',  # Invalid because name cannot be blank
          description: 'Updated description'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the project' do
        patch :update, params: valid_update_attributes
        project.reload
        expect(project.name).to eq('Updated Project Name')
        expect(project.description).to eq('Updated description')
      end

      it 'redirects to the project dashboard' do
        patch :update, params: valid_update_attributes
        expect(response).to redirect_to(project_dashboard_path(project))
      end

      it 'sets a success notice' do
        patch :update, params: valid_update_attributes
        expect(flash[:notice]).to eq('Project was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      before do
        @project = project
        allow(Project).to receive(:find).and_return(@project)
        allow(@project).to receive(:update).and_return(false)
        errors = double('errors')
        allow(errors).to receive(:full_messages).and_return(['Name cannot be blank'])
        allow(errors).to receive(:to_sentence).and_return('Name cannot be blank')
        allow(@project).to receive(:errors).and_return(errors)
      end

      it 'does not update the project' do
        original_name = @project.name
        patch :update, params: invalid_update_attributes
        expect(@project.name).to eq(original_name)
      end

      it 'renders the dashboard template' do
        patch :update, params: invalid_update_attributes
        expect(response).to redirect_to(project_dashboard_path(project))
      end

      it 'sets an alert message' do
        patch :update, params: invalid_update_attributes
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to eq('Name cannot be blank')
      end
    end

    context 'when project is not found' do
      it 'raises RecordNotFound error' do
        expect do
          patch :update, params: { project_id: 'invalid', project: valid_update_attributes[:project] }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end