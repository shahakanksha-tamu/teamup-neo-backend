# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportDataController, type: :controller do
  describe 'GET #index' do
    let(:user) do
      User.create!(first_name: 'FN', last_name: 'LN', contact: '2143454324', role: 'admin', email: 'test@gmail.com')
    end

    before do
      session[:user_id] = user.id
    end

    it 'renders the import data form' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'DELETE #delete_data' do
    let(:user) do
      User.create!(first_name: 'FN', last_name: 'LN', contact: '2143454324', role: 'admin', email: 'test@gmail.com')
    end

    let(:other_user) do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '2143454324', role: 'student', email: 'teststudent@gmail.com')
    end

    before do
      session[:user_id] = user.id
      delete :delete_data
    end

    it 'deletes all users except the current user' do
      expect(User.count).to eq(1)
      expect(User.first).to eq(user)
    end

    it 'sets a flash notice' do
      expect(flash[:notice]).to eq('All the records have been deleted successfully.')
    end

    it 'redirects to the import_path' do
      expect(response).to redirect_to(import_path)
    end
  end

  describe 'POST #upload_data' do
    let(:user) do
      User.create!(first_name: 'FN', last_name: 'LN', contact: '2143454324', role: 'admin', email: 'test@gmail.com')
    end

    let(:file_path) { Rails.root.join('spec/fixtures/files/sample_data.xlsx') }
    let(:file) { fixture_file_upload(file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    let(:invalid_file) { fixture_file_upload(file_path, 'text/plain') }

    before do
      session[:user_id] = user.id
    end

    context 'when no file is uploaded' do 
      it 'redirects to import_path without processing' do
        post :upload_data
        expect(flash[:notice]).to be_nil
      end
    end

    context 'when an invalid file format is uploaded' do
      before { post :upload_data, params: { fileUpload: invalid_file } }

      it 'sets an alert flash message' do
        expect(flash[:alert]).to match('An error occurred while processing the file')
      end

      it 'redirects to import_path' do
        expect(response).to redirect_to(import_path)
      end
    end

    context 'when a valid file is uploaded' do
      it 'calls the process_data method and imports users' do
        expect_any_instance_of(described_class).to receive(:process_data).and_call_original
        post :upload_data, params: { fileUpload: file }
        expect(flash[:notice]).to eq('File uploaded and data imported successfully!')
      end

      it 'redirects to import_path after successful import' do
        post :upload_data, params: { fileUpload: file }
        expect(response).to redirect_to(import_path)
      end
    end
  end

  describe 'Upload Errorneous File' do
    let(:user) do
      User.create!(first_name: 'FN', last_name: 'LN', contact: '2143454324', role: 'admin', email: 'test@gmail.com')
    end

    before do
      session[:user_id] = user.id
    end

    context 'when there is a missing required header' do
      let(:invalid_file_path) { Rails.root.join('spec/fixtures/files/invalid_headers.xlsx') }
      let(:invalid_header_file) { fixture_file_upload(invalid_file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }

      it 'sets an alert flash message with missing headers' do
        post :upload_data, params: { fileUpload: invalid_header_file }
        expect(flash[:alert]).to include('File has missing required columns')
      end
    end

    context 'when a row has missing required data' do
      let(:missing_data_file_path) { Rails.root.join('spec/fixtures/files/missing_data.xlsx') }
      let(:missing_data_file) { fixture_file_upload(missing_data_file_path, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
      let(:missing_data_file_path_csv) { Rails.root.join('spec/fixtures/files/missing_data.csv') }
      let(:missing_data_file_csv) { fixture_file_upload(missing_data_file_path_csv, 'text/csv') }

      it 'sets an alert flash message indicating the missing data' do
        post :upload_data, params: { fileUpload: missing_data_file }
        expect(flash[:alert]).to include('Row')
      end

      it 'sets an alert flash message indicating the missing data for csv file' do
        post :upload_data, params: { fileUpload: missing_data_file_csv }
        expect(flash[:alert]).to include('Row')
      end
    end
  end
end
