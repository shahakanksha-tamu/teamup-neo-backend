# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamInfoController, type: :controller do
  describe 'GET #index' do
    before do
      User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'student', email: 'firstname@gmail.com')
      User.create!(first_name: 'FN', last_name: 'LN', contact: '2143454324', role: 'admin', email: 'test@gmail.com')
      Project.create!(name: 'Test Project')
    end

    context 'when student assignment exists' do
      let(:project) do
        Project.find_by(name: 'Test Project')
      end

      let(:first_user) do
        User.find_by(email: 'firstname@gmail.com')
      end

      let(:second_user) do
        User.find_by(email: 'test@gmail.com')
      end

      before do
        student_user_id = User.find_by(email: 'test@gmail.com').id
        session[:user_id] = User.find_by(email: 'firstname@gmail.com').id
        StudentAssignment.create!(user_id: session[:user_id], project_id: project.id)
        StudentAssignment.create!(user_id: student_user_id, project_id: project.id)
      end

      it 'assigns the project name and team members' do
        get :index
        expect(assigns(:project_name)).to eq(project.name)
        expect(assigns(:team_members)).not_to include(first_user)
        expect(assigns(:team_members)).to include(second_user)
      end
    end
  end
end
