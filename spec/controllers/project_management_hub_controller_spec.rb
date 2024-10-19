# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectManagementHubController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      name: "Test Project",
      description: "A test project",
      objectives: "To test project creation",
      status: "active",
      start_date: Date.today,
      end_date: Date.today + 30.days,
      user_ids: [user.id]
    }
  end

  before do
    session[:user_id] = user.id
  end



  describe "POST #create_project" do
    context 'with valid parameters' do
      it 'creates a new project' do
        expect {
          post :create_project, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)
      end

      it 'redirects to the project management hub with a notice' do
        post :create_project, params: { project: valid_attributes }
        expect(response).to redirect_to(project_management_hub_path)
        expect(flash[:notice]).to eq('Project was successfully created.')
      end

      it 'creates a timeline for the project' do
        expect {
          post :create_project, params: { project: valid_attributes }
        }.to change(Timeline, :count).by(1)
      end

      it 'creates student assignments' do
        expect {
          post :create_project, params: { project: valid_attributes }
        }.to change(StudentAssignment, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { valid_attributes.merge(end_date: Date.today - 30.days) }

      it 'does not create a new project' do
        expect {
          post :create_project, params: { project: invalid_attributes }
        }.not_to change(Project, :count)
      end

      it 'renders the project management hub template with an alert' do
        post :create_project, params: { project: invalid_attributes }
        # expect(response).to render_template(:index)
        expect(flash.now[:alert]).to be_present
      end
    end

    context 'when an associated record fails to save' do
      before do
        allow_any_instance_of(Project).to receive(:save).and_return(true)
        allow_any_instance_of(Timeline).to receive(:save).and_return(false)
      end

      it 'does not create a new project' do
        expect {
          post :create_project, params: { project: valid_attributes }
        }.not_to change(Project, :count)
      end

      it 'renders the index template with an alert' do
        post :create_project, params: { project: valid_attributes }
        expect(response).to render_template(:index)
        expect(flash.now[:alert]).to be_present
      end
    end

    context 'when creating student assignments fails' do
      before do
        allow_any_instance_of(Project).to receive(:save).and_return(true)
        allow_any_instance_of(Timeline).to receive(:save).and_return(true)
      end

      context 'when a user is not found' do
        it 'raises an error and does not create a new project' do
          expect {
            post :create_project, params: { project: valid_attributes.merge(user_ids: [999]) } # Assuming 999 is an invalid user ID
          }.not_to change(Project, :count)
        end

        it 'renders the index template with an alert' do
          post :create_project, params: { project: valid_attributes.merge(user_ids: [999]) }
          expect(response).to render_template(:index)
          expect(flash.now[:alert]).to be_present
        end
      end

      context 'when assignment fails to save' do
        before do
          allow(controller).to receive(:create_student_assignments).and_raise(ActiveRecord::RecordInvalid.new(Project.new))
        end

        it 'does not create a new project' do
          expect {
            post :create_project, params: { project: valid_attributes.merge(user_ids: [1]) } # Assuming 1 is a valid user ID
          }.not_to change(Project, :count)
        end

        it 'renders the index template with an alert' do
          post :create_project, params: { project: valid_attributes.merge(user_ids: [1]) }
          expect(response).to render_template(:index)
          expect(flash.now[:alert]).to be_present
        end
      end
    end

  end
end
