require 'rails_helper'

RSpec.describe MilestonesController, type: :controller do
    let(:valid_attributes) {
        { title: 'Milestone 1', description: 'Description for milestone 1', due_date: Date.today + 1.week }
    }

    let(:invalid_attributes) {
        { title: '', description: '', due_date: nil }
    }

    describe "GET #index" do
        it "returns a success response" do
            Milestone.create! valid_attributes
            get :index
            expect(response).to be_successful
        end
    end

    describe "GET #show" do
        it "returns a success response" do
            milestone = Milestone.create! valid_attributes
            get :show, params: { id: milestone.to_param }
            expect(response).to be_successful
        end
    end

    describe "POST #create" do
        context "with valid params" do
            it "creates a new Milestone" do
                expect {
                    post :create, params: { milestone: valid_attributes }
                }.to change(Milestone, :count).by(1)
            end

            it "renders a JSON response with the new milestone" do
                post :create, params: { milestone: valid_attributes }
                expect(response).to have_http_status(:created)
                expect(response.content_type).to eq('application/json')
                expect(response.location).to eq(milestone_url(Milestone.last))
            end
        end

        context "with invalid params" do
            it "renders a JSON response with errors for the new milestone" do
                post :create, params: { milestone: invalid_attributes }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.content_type).to eq('application/json')
            end
        end
    end

    describe "PUT #update" do
        context "with valid params" do
            let(:new_attributes) {
                { title: 'Updated Milestone', description: 'Updated description', due_date: Date.today + 2.weeks }
            }

            it "updates the requested milestone" do
                milestone = Milestone.create! valid_attributes
                put :update, params: { id: milestone.to_param, milestone: new_attributes }
                milestone.reload
                expect(milestone.title).to eq('Updated Milestone')
                expect(milestone.description).to eq('Updated description')
                expect(milestone.due_date).to eq(Date.today + 2.weeks)
            end

            it "renders a JSON response with the milestone" do
                milestone = Milestone.create! valid_attributes
                put :update, params: { id: milestone.to_param, milestone: valid_attributes }
                expect(response).to have_http_status(:ok)
                expect(response.content_type).to eq('application/json')
            end
        end

        context "with invalid params" do
            it "renders a JSON response with errors for the milestone" do
                milestone = Milestone.create! valid_attributes
                put :update, params: { id: milestone.to_param, milestone: invalid_attributes }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.content_type).to eq('application/json')
            end
        end
    end

    describe "DELETE #destroy" do
        it "destroys the requested milestone" do
            milestone = Milestone.create! valid_attributes
            expect {
                delete :destroy, params: { id: milestone.to_param }
            }.to change(Milestone, :count).by(-1)
        end
    end
end