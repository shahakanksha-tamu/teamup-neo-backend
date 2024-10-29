# spec/controllers/resources_controller_spec.rb
require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:resource) { create(:resource, project: project) }
  let(:file) { fixture_file_upload(Rails.root.join('sample.pdf'), 'application/pdf') }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'assigns @project and @resources' do
      get :index, params: { project_id: project.id }
      expect(assigns(:project)).to eq(project)
      expect(assigns(:resources)).to eq(project.resources)
      expect(assigns(:resource)).to be_a_new(Resource)
    end

    it 'renders the index template' do
      get :index, params: { project_id: project.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #download' do
    it 'sends the file as an attachment' do
      resource.file.attach(file)
      get :download, params: { project_id: project.id, id: resource.id }
      expect(response.headers['Content-Disposition']).to include('attachment')
    end
  end

  describe 'GET #open' do
    it 'sends the file inline' do
      resource.file.attach(file)
      get :open, params: { project_id: project.id, id: resource.id }
      expect(response.headers['Content-Disposition']).to include('inline')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the resource and redirects to the index' do
      resource.file.attach(file)
      delete :destroy, params: { project_id: project.id, id: resource.id }
      expect(response).to redirect_to(project_resources_path(project))
      expect(flash[:success]).to eq('Resource was successfully removed.')
      expect(Resource.exists?(resource.id)).to be_falsey
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new resource and redirects to the index' do
        expect {
          post :create, params: { project_id: project.id, resource: { name: 'New Resource', file: file } }
        }.to change(Resource, :count).by(1)
        expect(response).to redirect_to(project_resources_path(project))
        expect(flash[:notice]).to eq('Resource was successfully created.')
      end
    end
    
    context 'saving fails' do
      it 'does not create a new resource and renders the new template' do
        allow_any_instance_of(Resource).to receive(:save).and_return(false) # Mock save to return false

        expect {
          post :create, params: { project_id: project.id, resource: { name: 'New Resource', file: file } }
        }.not_to change(Resource, :count)

        expect(response).to render_template(:new)
      end
    end

  end
end