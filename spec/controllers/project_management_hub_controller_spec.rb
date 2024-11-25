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

  let(:invalid_attributes) do
    {
      name: '', # Invalid because name cannot be blank
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

    it 'assigns the requested project to project' do
      get :team, params: { project_id: project.id }
      expect(assigns(:project)).to eq(project)
    end

    context 'when an associated record fails to save' do
      before do
        get :dashboard, params: { project_id: project.id }
      end

      it 'assigns @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'sets @show_sidebar to true' do
        expect(assigns(:show_sidebar)).to be true
      end

      it 'renders the dashboard template' do
        expect(response).to render_template(:dashboard)
      end
    end
  end

  describe 'GET #team' do
    context 'when the project exists' do
      before do
        get :team, params: { project_id: project.id }
      end

      it 'assigns @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'sets @show_sidebar to true' do
        expect(assigns(:show_sidebar)).to be true
      end

      it 'renders the team template' do
        expect(response).to render_template(:team)
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

      it 'assigns the requested project to project' do
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
        expect do
          get :dashboard, params: { project_id: -1 } # Invalid project ID
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #add_student' do
    let(:student) { create(:user) }
    let(:project) { create(:project) }

    context 'when the student is already assigned to a project' do
      let(:other_project) { create(:project) }

      before do
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
        allow_any_instance_of(Project).to receive(:add_student).and_return(true)
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

    context 'when a student is already assigned to a project' do
      before do
        allow(Project).to receive_message_chain(:joins, :where, :exists?).and_return(true) # rubocop:disable RSpec/MessageChain
      end

      it 'sets an error flash message' do
        post :add_student, params: { project_id: project.id, user_id: student.id }
        expect(flash[:error]).to include("#{student.email} is already assigned to a project")
      end
    end
  end

  describe 'DELETE #remove_student' do
    let(:student) { create(:user) }

    context 'when successfully removing a student' do
      before do
        allow_any_instance_of(Project).to receive(:remove_student).and_return(true)
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
  end

  describe 'POST #create_project' do
    context 'with valid parameters' do
      it 'creates a new project and assigns the current user to it' do
        expect do
          post :create_project, params: valid_attributes
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the project management hub with a success notice' do
        post :create_project, params: valid_attributes
        expect(response).to redirect_to(project_management_hub_path)
        expect(flash[:notice]).to eq('Project was successfully created.')
      end

      it 'creates associated student assignments' do
        expect do
          post :create_project, params: valid_attributes
        end.to change(StudentAssignment, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new project' do
        expect do
          post :create_project, params: invalid_attributes
        end.not_to change(Project, :count)
      end

      it 'redirects to the project management hub with an error alert' do
        post :create_project, params: invalid_attributes
        expect(response).to redirect_to(project_management_hub_path)
        expect(flash[:alert]).to eq("Name can't be blank")
      end
    end

    context 'when an associated record fails' do
      before do
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        allow_any_instance_of(Project).to receive_message_chain(:errors, :full_messages).and_return(["Error creating project"])
      end

      it 'does not create the project and shows an error message' do
        post :create_project, params: valid_attributes
        expect(flash[:alert]).to eq("Error creating project")
        expect(response).to redirect_to(project_management_hub_path)
      end
    end
  
  context 'when student assignment creation fails' do
    let(:error_message) { "Student assignment validation failed" }
    
    before do
      allow_any_instance_of(Project).to receive(:save).and_return(true)
      allow(controller).to receive(:create_student_assignments).and_raise(ActiveRecord::RecordInvalid.new(Project.new))
    end

    it 'does not create the project due to associated data error' do
      expect do
        post :create_project, params: valid_attributes
      end.not_to change(Project, :count)
    end

    it 'adds the error message to the project errors' do
      post :create_project, params: valid_attributes
      expect(assigns(:project).errors[:base]).to include(/Error in associated data:/)
    end

    it 'redirects to project management hub with error message' do
      post :create_project, params: valid_attributes
      expect(response).to redirect_to(project_management_hub_path)
      expect(flash[:alert]).to be_present
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
          name: '', # Invalid because name cannot be blank
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

      it 'sets a success flash message' do
        patch :update, params: valid_update_attributes
        expect(flash[:notice]).to eq('Project was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the project' do
        patch :update, params: invalid_update_attributes
        project.reload
        expect(project.name).to eq('Original Name')
      end

      it 'sets an error flash message' do
        patch :update, params: invalid_update_attributes
        expect(flash[:alert]).to eq("Name can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the project exists' do
      it 'deletes the project' do
        project_to_delete = create(:project)
        expect do
          delete :destroy, params: { project_id: project_to_delete.id }
        end.to change(Project, :count).by(-1)
      end

      it 'redirects to the project management hub' do
        delete :destroy, params: { project_id: project.id }
        expect(response).to redirect_to(project_management_hub_path)
      end

      it 'sets a success notice' do
        delete :destroy, params: { project_id: project.id }
        expect(flash[:notice]).to eq('Project was successfully deleted.')
      end
    end

    context 'when the project does not exist' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect do
          delete :destroy, params: { project_id: -1 } # Invalid project ID
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the project deletion fails' do
      before do
        allow_any_instance_of(Project).to receive(:destroy).and_return(false)
      end

      it 'does not delete the project and sets an error message' do
        project_to_fail = create(:project)
        delete :destroy, params: { project_id: project_to_fail.id }
        expect(flash[:alert]).to eq('Unable to delete the project.')
      end      
    end
  end
end
